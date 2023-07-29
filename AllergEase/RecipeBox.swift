//
//  RecipeBox.swift
//  AllergEase
//
//  Created by ryan on 7/28/23.
//

import SwiftUI

struct RecipeBox: View {
    let recipe: Recipe // Use the correct path to access the recipe

    @State private var image: UIImage? = nil // Add a State variable to store the fetched image

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image) // Use the fetched image here
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } else {
                // Show a placeholder image or loading indicator while the image is being fetched
                Color.gray
                    .frame(height: 250)
            }
            VStack {
                Spacer()
                Link(destination: URL(string: recipe.url)!){
                    Spacer()
                    VStack {
                        Spacer().frame(height: 20)
                        HStack {
                            Spacer().frame(width: 20)
                            Text(recipe.label)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "location")
                                .font(.largeTitle)
                            Spacer().frame(width: 20)
                        }
                        Spacer().frame(height: 20)
                    }
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .opacity(0.9)
            }
        }
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        .padding()
        .onAppear {
            loadImage() // Fetch the image when the view appears
        }
        
    }

    private func loadImage() {
        guard let url = URL(string: recipe.image) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                image = UIImage(data: data) // Update the State variable with the fetched image
            }
        }.resume()
    }
}
