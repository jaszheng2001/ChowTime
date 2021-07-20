//
//  RecipeData.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/26/21.
//

import Foundation

struct RecipeData: Decodable {
    let results: [Recipe]
    let offset: Int
    let number: Int
    let totalResults: Int
}

struct Recipe: Decodable {
    let id: Int?
    let title: String?
    let image: String?
    let imageType: String?
    let extendedIngredients: [Ingredients]?
    let nutrition: [String:[Nutrient]]?
    let vegetarian: Bool?
    let vegan: Bool?
    let glutenFree: Bool?
    let veryPopular: Bool?
    let healthScore: Float?
    let readyInMinutes: Int?
    let servings: Int?
    let cuisines: [String]?
    let diets: [String]?
    let analyzedInstructions: [AnalyzedInstructions]?
}

struct Ingredients: Decodable, CustomStringConvertible {
    let id: Int?
    let name: String?
    let originalString: String?
    let amount: Float?
    let measures: Measures?
    var description: String {
        if amount != nil {
            if amount!.truncatingRemainder(dividingBy: 1.0) == 0.0 {
                return "• \(String(Int(amount!))) \(measures?.us?.unitShort ?? "") \(name ?? "")"
            }
        }
        return "• \(String(amount ?? 0)) \(measures?.us?.unitShort ?? "") \(name ?? "")"
    }
}

struct Measures: Decodable {
    let us: Unit?
    let metric: Unit?
}

struct Unit: Decodable {
    let amount: Float?
    let unitShort: String?
    let unitLong: String?
}

struct AnalyzedInstructions: Decodable{
    let steps: [Steps]?
}

struct Steps: Decodable, CustomStringConvertible {
    let number: Int?
    let step: String?
    var description: String {return "\(String(number ?? 1)). \(step ?? "")"}
}

struct Nutrient: Decodable {
    let title: String?
    let name: String?
    let amount: Double?
    let unit: String?
    let percentDailyNeeds: Int?
    let indented: Bool?
}
