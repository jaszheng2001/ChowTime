//
//  WelcomeViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/13/21.
//

import UIKit
import Parse

class WelcomeViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var recommendedRecipes: RecipeData?
    var recipeManager = RecipeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        recipeManager.fetchRecipeBySearch(search: "Chicken Wing", number: 5, offset: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func onLogin(_ sender: Any) {
        if let username = emailTextField.text, let password = passwordTextField.text {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender:  nil)
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
    }
}

extension WelcomeViewController: RecipeManagerDelegate {
    func didReceivedRecipe(_ recipe: RecipeData) {
        recommendedRecipes = recipe
    }
}
