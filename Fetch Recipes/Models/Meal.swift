//
//  Meal.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import Foundation

class Meal: Codable {
    let mealName: String
    let mealThumbnailURL: String
    let id: String
    
    init(mealName: String, mealThumbnailURL: String, id: String) {
        self.mealName = mealName
        self.mealThumbnailURL = mealThumbnailURL
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealThumbnailURL = "strMealThumb"
        case id = "idMeal"
    }
}
