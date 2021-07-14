//
//  PlannerData.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/27/21.
//

import Foundation

struct ConnectUserData: Decodable {
    let status: String?
    let username: String?
    let hash: String?
}

struct DailyMealPlanData: Decodable {
    let nutritionSummary: [String: [Nutrient]]?
    let nutritionSummaryBreakfast: [String: [Nutrient]]?
    let nutritionSummaryLunch: [String: [Nutrient]]?
    let nutritionSummaryDinner: [String: [Nutrient]]?
    let date: Int?
    let day: String?
    let items: [MealPlanItem]?
}

struct MealPlanItem: Decodable {
    let id: Int?
    let slot: Int?
    let positiion: Int?
    let type: String?
    let value: MealPlanItemValue
}

struct MealPlanItemValue: Decodable {
    let id: Int?
    let imageType: String?
    let servings: Int?
    let readyInMinutes: Int?
    let title: String?
}

struct GeneratorData: Decodable {
    let meals: [MealPlanItemValue]
    let nutrients: DailyNutrients
}

struct DailyNutrients: Decodable {
    let calories: Float
    let protein: Float
    let fat: Float
    let carbohydrates: Float
}
