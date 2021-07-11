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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caloriesPB.progressClr = UIColor.systemBlue
        fatPB.progressClr = UIColor.systemGreen
        carbPB.progressClr = UIColor.systemPink
        proteinsPB.progressClr = UIColor.systemOrange
        plannerTableView.dataSource = self
        plannerTableView.delegate = self
        caloriesPB.setProgressWithAnimation(duration: 1, value: 0.8)
        fatPB.setProgressWithAnimation(duration: 1, value: 0.6)
        carbPB.setProgressWithAnimation(duration: 1, value: 0.8)
        proteinsPB.setProgressWithAnimation(duration: 1, value: 0.8)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
}

extension PlannerViewController: UITableViewDelegate{}

extension PlannerViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannerCell") as! PlannerCell
        return cell
    }
}
