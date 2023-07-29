import Foundation

class RecipeAPI {
    let appId = "09337508"
    let appKey = "c7c308ac118512a1cc9bf514bd7fce08"
    
    let recipeAPIBase = "https://api.edamam.com/api/recipes/v2"
       
       func getRecipes(for allergies: [AllergyType], completion: @escaping (Result<[Recipe], Error>) -> Void) {
           var urlComponents = URLComponents(string: recipeAPIBase)!
           urlComponents.queryItems = [
               URLQueryItem(name: "app_id", value: appId),
               URLQueryItem(name: "app_key", value: appKey),
               URLQueryItem(name: "type", value: "public"),
               URLQueryItem(name: "random", value: "true"),
           ]
           
           for allergy in allergies {
               urlComponents.queryItems?.append(URLQueryItem(name: "health", value: "\(allergy.rawValue)-free"))
           }
           
           let url = urlComponents.url!
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                   completion(.failure(error))
                   return
               }
               
               do {
                   
                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       
                       var newRecipes: [Recipe] = []
                       
                       if let hits = json["hits"] as? [[String: Any]]  {
                           for hit in hits {
                               if let recipe = hit["recipe"] as? [String: Any] {
                                   if let label = recipe["label"] as? String,
                                      let image = recipe["image"] as? String,
                                      let url = recipe["url"] as? String {
                                       
                                       let newRecipe = Recipe(label: label, image: image, url: url)
                                       newRecipes.append(newRecipe)
                                   }
                               }
                           }
                           completion(.success(newRecipes))
                       }
                   }
                   
                   
               } catch let error {
                   completion(.failure(error))
               }
           }
           task.resume()
       }
   }
