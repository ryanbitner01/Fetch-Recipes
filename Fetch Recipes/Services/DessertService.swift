//
//  DessertService.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import Foundation

class NetworkDessertService {
    static var instance: NetworkDessertService = NetworkDessertService()
    weak var mealDetailViewControllerDelegate: MealDetailViewControllerDelegate?
    var dessert: DessertRecipe? {
        didSet {
            mealDetailViewControllerDelegate?.updateView()
        }
    }
    
    let ingredientsCount = 20
    let instructionCount = 20
    
    var id: String = "" 
    
    func updateDessert() {
        mealDetailViewControllerDelegate?.startProgress()
        fetchDessert { result in
            switch result {
            case .success(let dessert):
                DispatchQueue.main.async {
                    self.dessert = dessert
                    self.mealDetailViewControllerDelegate?.stopProgress()
                }
            case .failure(let err):
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    self.mealDetailViewControllerDelegate?.stopProgress()
                }
            }
        }
    }
    
    func fetchDessert(completion: @escaping (Result<DessertRecipe, Error>) -> Void) {
        guard id != "" else {return}
        let baseURLString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID"
        var queryItems = [URLQueryItem]()
        let mealIDQuery = URLQueryItem(name: "i", value: id)
        queryItems.append(mealIDQuery)
        var urlComponents = URLComponents(string: baseURLString)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, err in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    guard let dict = json as? [String: Any],
                          let meals = dict["meals"] as? [Any],
                          let dessertDict = meals[0] as? [String: Any],
                          let dessertData = self.getDessertDataFromJSON(dict: dessertDict) else {return}
                    let dessert = try jsonDecoder.decode(DessertRecipe.self, from: dessertData)
                    completion(.success(dessert))
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }
        dataTask.resume()
        
    }
    
    func getDessertDataFromJSON(dict: [String: Any]) -> Data? {
        let ingredients = self.getIngredientsFromJson(meals: dict)
        guard let instructions = dict["strInstructions"] else {return nil}
        guard let dessertName = dict["strMeal"] else {return nil}
        guard let dessertThumbnailURL = dict["strMealThumb"] else {return nil}
        let newJSON: [String: Any] = [
            "dessertName": dessertName,
            "dessertInstructions": instructions,
            "dessertIngredients": ingredients.ingredients,
            "dessertIngredientMeasurements": ingredients.ingredientMeasurements,
            "dessertThumbnailURL": dessertThumbnailURL
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newJSON, options: .prettyPrinted)
            return jsonData
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    
    func getIngredientsFromJson(meals: [String: Any]) -> (ingredients: [String], ingredientMeasurements: [String: String]){
        var ingredients = [String]()
        var ingredientMeasurements = [String: String]()
        for i in 0...ingredientsCount {
            guard let ingredient = meals["strIngredient\(i)"] as? String, let measurement = meals["strMeasure\(i)"] as? String, ingredient != "" else {continue}
            ingredients.append(ingredient)
            ingredientMeasurements[ingredient] = measurement
        }
        
        return (ingredients, ingredientMeasurements)
    }
    
}
