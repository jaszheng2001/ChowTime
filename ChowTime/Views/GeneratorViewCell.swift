//
//  GeneratorViewCell.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/30/21.
//

import UIKit

class GeneratorViewCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var index = -1
    var prevVC: UIViewController?
    var meal: MealPlanItemValue?
    var planner = RecipePlannerManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        planner.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToPlanner(_ sender: Any) {
        let date = String(Int(NSDate().timeIntervalSince1970))
        let data: [String: Any]
        data = ["id": meal?.id ?? 0,
                "imageType": meal?.imageType ?? "",
                "title": meal?.title ?? "",
                "readyInMinutes": meal?.readyInMinutes ?? 0,
                "servings": meal?.servings ?? 0]
        print(data)
        planner.addToMealPlan(date: date, type: "RECIPE", meal: data)
    }
}

extension GeneratorViewCell: PlannerDelegate{
    func didReceivedUserData(_ data: ConnectUserData) {}
    
    func didReceivedMealData(_ data: DailyMealPlanData?,_ update: Bool) {}
    
    func didReceivedGeneratorData(_ data: GeneratorData) {}
    
    func didUpdatedPlanner() {
        DispatchQueue.main.async {
            self.addButton.setTitle("SUCCESS", for: .normal)
            self.addButton.setTitleColor(UIColor.systemGreen, for: .normal)
            self.addButton.isEnabled = false
            if let vc = self.prevVC as? DashboardViewController {
                vc.recipePlanner.getTodayMealPlan(update: true)
                vc.genCellStatus[self.index] = true
            }
        }
    }
    
}
