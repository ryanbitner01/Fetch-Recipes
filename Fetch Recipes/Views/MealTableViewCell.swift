//
//  MealTableViewCell.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    static let identifier = "MealCell"
    var meal: Meal?
    
    @IBOutlet weak var mealThumbnailImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    func updateCell() {
        updateImage()
        updateNameLabel()
    }
    
    func updateNameLabel() {
        self.mealNameLabel.text = meal?.mealName
    }
    
    func updateImage() {
        guard let meal = meal else {
            return
        }
        mealThumbnailImageView.loadImage(url: meal.mealThumbnailURL)
        mealThumbnailImageView.layer.cornerRadius = 5
    }

}

