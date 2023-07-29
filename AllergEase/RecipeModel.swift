// RecipeModel.swift

import Foundation

struct Recipe: Identifiable {
    var id: UUID = UUID()
    let label: String
    let image: String
    let url: String
}

struct RecipeModelResponse: Codable {
    let from: Int
    let to: Int
    let count: Int
    let hits: [Hit]

    struct Hit: Codable {
        let recipe: RecipeModel
    }
}

struct RecipeModel: Codable {
    let from: Int
    let to: Int
    let count: Int
    let links: Links
    let hits: [Hit]

    struct Links: Codable {
        let selfLink: Link
        let nextLink: Link

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case nextLink = "next"
        }
    }

    struct Link: Codable {
        let href: String
        let title: String
    }

    struct Hit: Codable {
        let recipe: Recipe
        let links: Links

        enum CodingKeys: String, CodingKey {
            case recipe
            case links = "_links"
        }
    }

    struct Recipe: Codable {
        let uri: String
        let label: String
        let image: String
        let source: String
        let url: String
        let shareAs: String
        let yield: Int
        let dietLabels: [String]
        let healthLabels: [String]
        let cautions: [String]
        let ingredientLines: [String]
        let ingredients: [Ingredient]
        let calories: Double
        let glycemicIndex: Double
        let totalCO2Emissions: Double
        let co2EmissionsClass: String
        let totalWeight: Double
        let cuisineType: [String]
        let mealType: [String]
        let dishType: [String]
        let instructions: [String]
        let tags: [String]
        let externalId: String
        let totalNutrients: [String: Nutrient]
        let totalDaily: [String: Nutrient]
        let digest: [Digest]

        struct Ingredient: Codable {
            let text: String
            let quantity: Double
            let measure: String
            let food: String
            let weight: Double
            let foodId: String
        }

        struct Nutrient: Codable {
            let label: String
            let quantity: Double
            let unit: String
        }

        struct Digest: Codable {
            let label: String
            let tag: String
            let schemaOrgTag: String
            let total: Double
            let hasRDI: Bool
            let daily: Double
            let unit: String
            let sub: [String: Nutrient]
        }
    }
}
