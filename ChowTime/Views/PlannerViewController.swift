//
//  PlannerViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/10/21.
//

import UIKit

class PlannerViewController: UIViewController {
    @IBOutlet weak var caloriesPB: CircularProgressBarView!
    @IBOutlet weak var fatPB: CircularProgressBarView!
    @IBOutlet weak var carbPB: CircularProgressBarView!
    @IBOutlet weak var proteinsPB: CircularProgressBarView!
    @IBOutlet weak var plannerTableView: UITableView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    var plannerManager = RecipePlannerManager()
    var nutritionSummary: [String:[Nutrient]]?
    var meals: [MealPlanItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesPB.progressClr = UIColor.systemBlue
        fatPB.progressClr = UIColor.systemGreen
        carbPB.progressClr = UIColor.systemPink
        proteinsPB.progressClr = UIColor.systemOrange
        plannerTableView.dataSource = self
        plannerTableView.delegate = self
        caloriesPB.setProgressWithAnimation(duration: 1, value: 0)
        fatPB.setProgressWithAnimation(duration: 1, value: 0)
        carbPB.setProgressWithAnimation(duration: 1, value: 0)
        proteinsPB.setProgressWithAnimation(duration: 1, value: 0)
        plannerManager.delegate = self
        plannerManager.getTodayMealPlan(update: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.hidesBackButton = true
        plannerManager.getTodayMealPlan(update: true)
    }
}

extension PlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.item)")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if meals?.count == 0 || meals == nil{
            return "YOU HAVE NO MEALS PLANNED FOR THE DAY"
        }
        return "MEALS"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "System", size: 16.0)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
}

extension PlannerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell") as! PlannerCell
        cell.prevView = self
        if let meal = meals?[indexPath.item] {
            cell.value = meal
            let urlString = "https://spoonacular.com/recipeImages/\(meal.value.id!)-90x90.\(meal.value.imageType!)"
            let url = URL(string: urlString)!
            cell.recipeImageView.af.setImage(withURL: url)
            cell.nameLabel.text = meal.value.title
            cell.timeLabel.text = "\(String(meal.value.readyInMinutes ?? 0)) Minutes"
            cell.serivngsLabel.text = "\(String(meal.value.servings ?? 1)) People"
        }
        return cell
    }
}

extension PlannerViewController: PlannerDelegate{
    func didUpdatedPlanner() {}
    
    func didReceivedUserData(_ data: ConnectUserData) {}
    
    func didReceivedMealData(_ data: DailyMealPlanData?, _ update: Bool) {
        DispatchQueue.main.async {
            if let nutrition = data?.nutritionSummary {
                self.nutritionSummary = nutrition
                if let calories = data?.nutritionSummary?["nutrients"]?[0].amount {
                    self.caloriesLabel.text = String(Int(calories))
                }
                if let calProgress = data?.nutritionSummary?["nutrients"]?[0].percentDailyNeeds{
                    if self.caloriesPB.prog != Float(calProgress)/100 {
                        self.caloriesPB.setProgressWithAnimation(duration: 1, value: Float(calProgress)/100)
                    }
                }
                if let fat = data?.nutritionSummary?["nutrients"]?[1].amount {
                    self.fatLabel.text = String(Int(fat))
                    
                }
                if let fatProgress = data?.nutritionSummary?["nutrients"]?[1].percentDailyNeeds{
                    if self.fatPB.prog != Float(fatProgress)/100 {
                        self.fatPB.setProgressWithAnimation(duration: 1, value: Float(fatProgress)/100)
                    }
                }
                if let carb = data?.nutritionSummary?["nutrients"]?[2].amount {
                    self.carbLabel.text = String(Int(carb))
                    
                }
                if let carbProgress = data?.nutritionSummary?["nutrients"]?[2].percentDailyNeeds{
                    if self.carbPB.prog != Float(carbProgress)/100 {
                        self.carbPB.setProgressWithAnimation(duration: 1, value: Float(carbProgress)/100)
                    }
                }
                if let proteins = data?.nutritionSummary?["nutrients"]?[3].amount {
                    self.proteinsLabel.text = String(Int(proteins))
                    
                }
                if let proteinsProgress = data?.nutritionSummary?["nutrients"]?[3].percentDailyNeeds{
                    if self.proteinsPB.prog != Float(proteinsProgress)/100 {
                        self.proteinsPB.setProgressWithAnimation(duration: 1, value: Float(proteinsProgress)/100)
                    }
                }
            }
            if let items = data?.items {
                self.meals = items
            }
            self.plannerTableView.reloadData()
        }
    }
    
    func didReceivedGeneratorData(_ data: GeneratorData) {}
}
