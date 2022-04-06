//
//  MealListTableViewController.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/29/22.
//

import UIKit

// MARK: - View Controller

class MealListTableViewController: UIViewController {
    @IBOutlet weak var mealTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    enum segueID: String {
        case mealDetailView
    }
    
    var mealService: MealService = NetworkMealsService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealService.mealListTableViewControllerDelegate = self
        self.mealService.updateMeals()
        self.mealTableView.delegate = self
        self.mealTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UITableViewCell {
            if let dest = segue.destination as? MealDetailViewController {
                guard let indexPath = mealTableView.indexPath(for: sender) else {return}
                let meal = mealService.meals[indexPath.row]
                let id = meal.id
                dest.dessertService.mealDetailViewControllerDelegate = dest
                dest.dessertService.id = id
                
            }
        }
    }
}

// MARK: - UITableView Data Source and Delegate

extension MealListTableViewController:  UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealService.meals.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as? MealTableViewCell
        if cell == nil {
            cell = MealTableViewCell()
        }
        let meal = mealService.meals[indexPath.row]
        cell?.meal = meal
        cell?.updateCell()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: segueID.mealDetailView.rawValue, sender: cell)
    }
}

//MARK: - MealListTableViewControllerDelegate


protocol MealListTableViewControllerDelegate {
    func updateListView()
    func startProgress()
    func stopProgress()
}

extension MealListTableViewController: MealListTableViewControllerDelegate {
    func startProgress() {
        activityIndicator.isHidden = false
    }
    
    func stopProgress() {
        activityIndicator.isHidden = true
    }
    
    func updateListView() {
        self.mealTableView.reloadData()
    }
}
