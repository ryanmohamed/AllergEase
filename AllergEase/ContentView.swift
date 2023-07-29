import SwiftUI

struct ContentView: View {
    @State private var selectedAllergies: [AllergyType] = []
    @State private var isShowingDrawer = false
    @State private var recipes: [Recipe] = [] // Changed this to an array since API might return multiple recipes

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isShowingDrawer = true
                        }
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    Spacer().frame(width: 40)
                    Text("AllergEase")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color("AllergEase").ignoresSafeArea())
                Spacer()
                
                VStack {
                    if recipes.count == 0 {
                        Spacer()
                        Image(systemName: "arrow.up.backward")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFill()
                            .font(.title)
                            .foregroundColor(.primary)
                        Spacer().frame(height: 30)
                        HStack {
                            Spacer().frame(width: 30)
                            Text("Select some allergies in the drawer to get some recipe suggestion!")
                                .font(.title)
                                .multilineTextAlignment(.center)
                            Spacer().frame(width: 30)
                        }
                        Spacer()
                    }
                    else {
                        ScrollView {
                            LazyVStack {
                                ForEach(recipes) { recipe in
                                    RecipeBox(recipe: recipe)
                                        .padding(.bottom, 4)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    // Fetch initial recipes when ContentView appears
                    fetchInitialRecipes()
                }
                .onChange(of: selectedAllergies) { _ in
                    fetchRecipesForAllergies()
                }
                
                
            }

            AllergyDrawer(selectedAllergies: $selectedAllergies, isShowing: $isShowingDrawer)
                .transition(.move(edge: .leading))
            
        }.gesture(DragGesture().onEnded {
            if $0.translation.width > 100 {
                withAnimation {
                    self.isShowingDrawer = false
                }
            }
        })
    }

    private func fetchInitialRecipes() {
        RecipeAPI().getRecipes(for: []) { result in
            switch result {
            case .success(let data):
                self.recipes = data
            case .failure(let error):
                // Handle API error here
                print("API Error: \(error)")
            }
        }
    }

    private func fetchRecipesForAllergies() {
        RecipeAPI().getRecipes(for: selectedAllergies) { result in
            switch result {
            case .success(let data):
                
                
                
                self.recipes = data
            case .failure(let error):
                // Handle API error here
                print("API Error: \(error)")
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
