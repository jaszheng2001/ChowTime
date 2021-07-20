//
//  ResultsViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/13/21.
//

import UIKit
import AlamofireImage

class ResultsViewController: UIViewController
{
    @IBOutlet weak var resultsTable: UITableView!
    var searchText: String?
    var category: String?
    var recipeManager = RecipeManager()
    var results: [Recipe]?
    var selectedID: Int?
    var selectedRecipeData: Recipe?
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTable.dataSource = self
        resultsTable.delegate = self
        recipeManager.delegate = self
        if let search = searchText{
            recipeManager.fetchRecipeBySearch(search: search, number: 10, offset: 0)
            print(search)
        } else {
            recipeManager.fetchRecipeByCuisine(search: category!, number: 10, offset: 0)
            print(category!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ResultsRecipeCard") {
            let dest = segue.destination as! RecipeViewController
            dest.id = selectedID
            dest.recipeData = selectedRecipeData
        }
    }
}
extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        let recipe = results?[indexPath.item]
        selectedID = recipe?.id
        selectedRecipeData = recipe
        self.performSegue(withIdentifier: "ResultsRecipeCard", sender: nil)
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        if let recipe = results?[indexPath.item] {
            cell.recipe = recipe
            let urlString = "https://spoonacular.com/recipeImages/\(recipe.id!)-90x90.\(recipe.imageType!)"
            if let url = URL(string: urlString) {
                cell.recipeImage?.af.setImage(withURL: url)
                cell.recipeImage.setImageColor(color: UIColor.gray)
            }
            if let title = recipe.title {
                cell.recipeName.text = title
            }
            if let readyIn = recipe.readyInMinutes {
                cell.readyInLabel.text = "\(readyIn) Minutes"
            }
            if let servings = recipe.servings {
                cell.servingsLabel.text = "\(servings) People"
            }
            if let calories = recipe.nutrition?["nutrients"]?[0].amount {
                cell.caloriesLabel.text = "\(String(Int(calories))) Calories"
            }
        }
        return cell
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension ResultsViewController: RecipeManagerDelegate {
    func didReceivedSingleRecipe(_ recipe: Recipe) {
    }
    
    func didReceivedRecipe(_ recipe: RecipeData) {
        DispatchQueue.main.async {
            self.results = recipe.results
            self.resultsTable.reloadData()
        }
        
    }
    
    
}
