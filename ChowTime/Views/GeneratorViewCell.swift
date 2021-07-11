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
    var recipeId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToPlanner(_ sender: Any) {
        print(nameLabel.text)
    }
    
}
