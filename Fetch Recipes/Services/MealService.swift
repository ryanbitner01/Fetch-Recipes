//
//  DessertService.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import Foundation

private struct MealsResponse: Codable {
    let meals: [Meal]
}

protocol MealService {
    var meals: [Meal] { get set }
    static var  instance: MealService { get }
    var mealListTableViewControllerDelegate: MealListTableViewControllerDelegate? {get set}
    func updateMeals()
}

private enum NetworkDesserServiceError: Error {
    case noURL
}

extension NetworkDesserServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noURL:
            return "Couldn't get URL!"
        }
    }
}

class NetworkMealsService: MealService {
    var mealListTableViewControllerDelegate: MealListTableViewControllerDelegate?
    
    static let instance: MealService = NetworkMealsService()
    
    var meals: [Meal] {
        didSet {
            mealListTableViewControllerDelegate?.updateListView()
        }
    }
    
    init() {
        self.meals = []
    }
    
    func updateMeals() {
        self.mealListTableViewControllerDelegate?.startProgress()
        fetchMeals { result in
            switch result {
            case .success(let meals):
                DispatchQueue.main.async {
                    self.meals = meals
                    self.mealListTableViewControllerDelegate?.stopProgress()
                }
            case .failure(let err):
                print(err.localizedDescription)
                self.mealListTableViewControllerDelegate?.stopProgress()
            }
        }
    }
    
    private func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        let baseURLString = "https://www.themealdb.com/api/json/v1/1/filter.php"
        var urlComponents = URLComponents(string: baseURLString)
        let queryObject = URLQueryItem(name: "c", value: "Dessert")
        var queryItems = [URLQueryItem]()
        queryItems.append(queryObject)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {return completion(.failure(NetworkDesserServiceError.noURL)) }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, err in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                data.prettyPrintedJSONString()
                do {
                    let mealsResponse = try jsonDecoder.decode(MealsResponse.self, from: data)
                    completion(.success(mealsResponse.meals))
                } catch let err {
                    completion(.failure(err))
                }
            }
            if let err = err {
                completion(.failure(err))
            }
        }
        dataTask.resume()
    }
    
    
}

class MockDessertService: MealService {
    var mealListTableViewControllerDelegate: MealListTableViewControllerDelegate?
    
    static var instance: MealService = MockDessertService()
    
    var meals: [Meal]
    
    init() {
        self.meals = []
    }
    
    func updateMeals() {
        let fakeMeals: [Meal] = [
            Meal(mealName: "Test1",
                 mealThumbnailURL: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg",
                 id: "01"),
            Meal(mealName: "Test2",
                 mealThumbnailURL: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg",
                 id: "02"),
            Meal(mealName: "Test3",
                 mealThumbnailURL: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg",
                 id: "03"),
        ]
        self.meals = fakeMeals
    }
    
    
}

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
                JSONSerialization.jsonObject(with: self,
                                             options: []),
            let jsonData = try?
                JSONSerialization.data(withJSONObject:
                                        jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
                                          encoding: .utf8) else {
            print("Failed to read JSON Object.")
            return
        }
        print(prettyJSONString)
    }
}
