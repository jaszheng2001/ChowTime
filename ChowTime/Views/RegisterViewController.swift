//
//  RegisterViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/13/21.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sexField: UISegmentedControl!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    let user = PFUser()
    var plannerManager = RecipePlannerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.tintColor = UIColor.black
        plannerManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegister(_ sender: Any) {
        if let name = nameField.text, let height = heightField.text, let weight = weightField.text,
           let email = emailField.text,
           let password = passwordField.text, let confirmPassword = confirmPasswordField.text {
            if (password != confirmPassword) {}
            else {
            let sex = (sexField.selectedSegmentIndex == 0 ? "Male" : "Female" )
                user["name"] = name
                user["sex"] = sex
                user["height"] = Int(height)
                user["weight"] = Int(weight)
                user.username = email
                user.password = password
                user.email = email
                plannerManager.connectUser(name: name, email: email)
            }
        } else {
            print("All fields are required")
        }
    }
}

extension RegisterViewController: PlannerDelegate {
    func didReceivedMealData(_ data: DailyMealPlanData) {}
    
    func didReceivedUserData(_ data: ConnectUserData) {
        user["spoonacularUsername"] = data.username
        user["spoonacularHash"] = data.hash
        print(user)
        user.signUpInBackground{ (success, error) in
            if success {
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
}
