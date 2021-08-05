//
//  ProfileViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/18/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()
        if (user != nil) {
            nameField.text = user!["name"] as! String
            emailField.text = user!.username!
            heightField.text = "\(user!["height"]!)"
            weightField.text = "\(user!["weight"]!)"
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        print(PFUser.current())
        if let name = nameField.text, let height = heightField.text, let weight = weightField.text,
           let email = emailField.text, let password = passwordField.text {
            PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
                if user != nil {
                    user!["name"] = name
                    user!["email"] = email
                    user!["height"] = Int(height)
                    user!["weight"] = Int(weight)
                    user!.saveInBackground{(success, error) in
                        if success {
                            print("successfully updated")
                        } else {
                            print("error!")
                        }
                    }
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let WelcomeNavigationController = main.instantiateViewController(withIdentifier: "WelcomeNavigationController")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = WelcomeNavigationController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
