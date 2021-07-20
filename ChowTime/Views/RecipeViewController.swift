//
//  RecipeViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/16/21.
//

import UIKit
import AlamofireImage

struct RecipeSection {
    var name: String
    var items: [CustomStringConvertible]?
}

class RecipeViewController: UIViewController {
    @IBOutlet weak var recipeTableView: UITableView!
    var recipeManager = RecipeManager()
    var sections: [RecipeSection]?
    var id: Int?
    var recipeData: Recipe?
    var name: String?
    var servings: Int?
    var time: Int?
    var imageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeManager.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        sections = []
        if recipeData != nil{
            name = recipeData?.title
            imageURL = recipeData?.image
            time = recipeData?.readyInMinutes
            servings = recipeData?.servings
            sections?.append(RecipeSection(name: "Ingredients", items: recipeData?.extendedIngredients))
            sections?.append(RecipeSection(name: "Cuisines", items: recipeData?.cuisines))
            if recipeData?.analyzedInstructions?.count ?? 0 >= 1 {
                sections?.append(RecipeSection(name: "Instructions", items: recipeData?.analyzedInstructions?[0].steps))
            } else {
                sections?.append(RecipeSection(name: "Instructions", items: ["Instructions not found"]))
            }
        } else {
            if let recipeId = id {
                recipeManager.fetchRecipeById(id: recipeId)
            }
        }
        recipeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension RecipeViewController: UITableViewDelegate{}

extension RecipeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return sections?[section - 1].name ?? ""
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (sections?.count  ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return sections?[section - 1].items?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.recipeTitle.text = name ?? ""
            if let readyIn = time {
                cell.timeLabel.text = "\(String(describing: readyIn)) Minutes"
            }
            cell.servingsField.text = String(servings ?? 1)
            if let url = URL(string: imageURL ?? "") {
                cell.imgView.af.setImage(withURL: url)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
            cell.txtLabel.text = sections?[indexPath.section-1].items?[indexPath.item].description
            return cell
        }
    }
}

extension RecipeViewController: RecipeManagerDelegate {
    func didReceivedRecipe(_ recipe: RecipeData) {}
    func didReceivedSingleRecipe(_ recipe: Recipe) {
        DispatchQueue.main.async {
            let recipeData = recipe
            self.name = recipeData.title
            self.imageURL = recipeData.image
            self.time = recipeData.readyInMinutes
            self.servings = recipeData.servings
            self.sections?.append(RecipeSection(name: "Ingredients", items: recipeData.extendedIngredients))
            self.sections?.append(RecipeSection(name: "Cuisines", items: recipeData.cuisines))
            if recipeData.analyzedInstructions?.count ?? 0 >= 1 {
                self.sections?.append(RecipeSection(name: "Instructions", items: recipeData.analyzedInstructions?[0].steps))
            } else {
                self.sections?.append(RecipeSection(name: "Instructions", items: ["Instructions not found"]))
            }
            self.recipeTableView.reloadData()
        }
        
    }
}
