//
//  PlannerCell.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/10/21.
//

import UIKit

class PlannerCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var serivngsLabel: UILabel!
    var prevView: UIViewController?
    var value: MealPlanItem?
    var planner = RecipePlannerManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        planner.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func removePressed(_ sender: Any) {
        planner.deleteFromPlanner(id: String(value?.id ?? 0))
        print("Removed from planner")
    }
}

extension PlannerCell: PlannerDelegate{
    func didReceivedUserData(_ data: ConnectUserData) {
    }
    
    func didReceivedMealData(_ data: DailyMealPlanData?, _ update: Bool) {
    }
    
    func didReceivedGeneratorData(_ data: GeneratorData) {
    }
    
    func didUpdatedPlanner() {
        if let view = prevView {
            let vc = view as! PlannerViewController
            vc.plannerManager.getTodayMealPlan(update: true)
        }
    }
    
    
}
