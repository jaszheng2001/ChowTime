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
    let nutrition: [String:[Nutrient]]?
}

struct Nutrient: Decodable {
    let title: String?
    let name: String?
    let amount: Double?
    let unit: String?
    let percentDailyNeeds: Int?
}
