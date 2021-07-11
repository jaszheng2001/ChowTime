//
//  DashboardViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/13/21.
//

import UIKit
import AlamofireImage

class DashboardViewController: UIViewController {
    @IBOutlet weak var dailyCaloriesLabel: UILabel!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var progressBar: CircularProgressBarView!
    @IBOutlet weak var generatorTableView: UITableView!
    var recommendedRecipes: RecipeData?
    var mealGenerator: [MealPlanItemValue]?
    var generatorNutrients: DailyNutrients?
    var recipeManager = RecipeManager()
    var recipePlanner = RecipePlannerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        recipeManager.delegate = self
        recipeManager.fetchRecipeBySearch(search: "Chicken Wing", number: 5, offset: 0)
        recipePlanner.delegate = self
        recipePlanner.getTodayMealPlan()
        generatorTableView.dataSource = self
        progressBar.progressClr = UIColor(red: 0, green: 0.3373, blue: 0.8784, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
}

extension DashboardViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
}

extension DashboardViewController:
    UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
        let recipe = recommendedRecipes?.results[indexPath.item]
        if let title = recipe?.title {
            cell.recipeNameLabel.text = title
        }
        if let calories = recipe?.nutrition?["nutrients"]?[0].amount {
            cell.caloriesLabel.text = "\(String(Int(calories))) Calories"
        }
        if let urlString = recipe?.image {
            let url = URL(string: urlString)!
            cell.recipeImageView.af.setImage(withURL: url)
        }
        return cell
    }
}

extension DashboardViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealGenerator?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneratorViewCell", for: indexPath) as! GeneratorViewCell
        if let meal = mealGenerator?[indexPath.item] {
            cell.recipeId = meal.id
            let urlString = "https://spoonacular.com/recipeImages/\(meal.id!)-90x90.\(meal.imageType!)"
            let url = URL(string: urlString)!
            print(url)
            cell.recipeImageView.af.setImage(withURL: url)
            cell.nameLabel.text = meal.title
            cell.timeLabel.text = "\(String(meal.readyInMinutes ?? 0)) Minutes"
            cell.servingsLabel.text = "\(String(meal.servings ?? 1)) People"
        }
        return cell
    }
}

extension DashboardViewController: RecipeManagerDelegate{
    func didReceivedRecipe(_ recipe: RecipeData) {
        recommendedRecipes = recipe
        DispatchQueue.main.async {
            self.recommendedCollectionView.reloadData()
        }
    }
}

extension DashboardViewController: PlannerDelegate {
    func didReceivedUserData(_ data: ConnectUserData) {}
    
    func didReceivedMealData(_ data: DailyMealPlanData?) {
        DispatchQueue.main.async {
            if data == nil {
                self.dailyCaloriesLabel.text = "0"
                self.progressBar.setProgressWithAnimation(duration: 1, value: 0.0)
                self.recipePlanner.generateMealPlan(tFrame: "day", target: 2000)
            } else {
                if let calories = data?.nutritionSummary?["nutrients"]?[0].amount {
                    self.dailyCaloriesLabel.text = String(Int(calories))
                    self.recipePlanner.generateMealPlan(tFrame: "day", target: 2000 - Int(calories))
                }
                if let progress = data?.nutritionSummary?["nutrients"]?[0].percentDailyNeeds {
                    self.progressBar.setProgressWithAnimation(duration: 1, value: Float(Float(progress)/100))
                }
            }
        }
    }
    
    func didReceivedGeneratorData(_ data: GeneratorData) {
        DispatchQueue.main.async {
            self.mealGenerator = data.meals
            self.generatorNutrients = data.nutrients
            self.generatorTableView.reloadData()
        }
    }
}
