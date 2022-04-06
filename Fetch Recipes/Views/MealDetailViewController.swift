//
//  MealDetailViewController.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import UIKit

protocol MealDetailViewControllerDelegate: AnyObject {
    func updateView()
    func startProgress()
    func stopProgress()
}

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var dessertThumbnailImageView: UIImageView!
    @IBOutlet weak var dessertNameLabel: UILabel!
    @IBOutlet weak var dessertInstructionLabel: UILabel!
    @IBOutlet weak var dessertIngredientsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dessertService: NetworkDessertService = NetworkDessertService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dessertService.mealDetailViewControllerDelegate = self
        self.dessertService.updateDessert()
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        guard let urlString = dessertService.dessert?.dessertThumbnailURL else {return}
        self.dessertThumbnailImageView.loadImage(url: urlString)

    }
    
    func setupNameLabel() {
        self.dessertNameLabel.text = dessertService.dessert?.dessertName
        self.view.updateConstraintsIfNeeded()

    }
    
    func setupInstructionLabel() {
        self.dessertInstructionLabel.text = dessertService.dessert?.dessertInstructions

    }
    
    func setupIngredientLabel() {
        self.dessertIngredientsLabel.text = self.dessertService.dessert?.ingredientString()
        self.view.updateConstraintsIfNeeded()

    }

}

extension MealDetailViewController: MealDetailViewControllerDelegate {
    func startProgress() {
        self.activityIndicator.isHidden = false
    }
    
    func stopProgress() {
        self.activityIndicator.isHidden = true
    }
    
    func updateView() {
        setupImageView()
        setupNameLabel()
        setupIngredientLabel()
        setupInstructionLabel()
    }
}
