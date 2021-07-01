//
//  RecommendedCollectionViewCell.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/20/21.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    let recipeId: Int? = nil
}
