//
//  LabelCell.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/16/21.
//

import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet weak var txtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
