//
//  Dessert.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import Foundation

struct DessertRecipe: Codable {
    let dessertName: String
    let dessertInstructions: String
    let dessertIngredients: [String]
    let dessertIngredientMeasurements: [String: String]
    let dessertThumbnailURL: String
    
    func ingredientString() -> String {
        var emptyString = ""
        for ingredient in dessertIngredients {
            if let measurement = dessertIngredientMeasurements[ingredient] {
                let newIngredientString = "- \(ingredient) \(measurement) \n"
                emptyString.append(newIngredientString)
            }
        }
        return emptyString
    }
}
