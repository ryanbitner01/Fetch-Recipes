//
//  IngredientTableViewCell.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/30/22.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    static let identifier = "IngredientCell"
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredientName: String = ""
    var ingredientMeasurement: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        self.ingredientLabel.text = "\(ingredientName) \(ingredientMeasurement)"
    }

}
