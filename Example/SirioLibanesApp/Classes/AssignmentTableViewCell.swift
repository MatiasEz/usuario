//
//  AssignmentTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet public weak var friendLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      self.selectionStyle = UITableViewCellSelectionStyle.none
    }

}
