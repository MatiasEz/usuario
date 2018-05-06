//
//  SongTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var rankingImage: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    override var tag : Int {
        didSet {
            self.plusButton.tag = self.tag
        }
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      self.selectionStyle = UITableViewCellSelectionStyle.none
      
      self.plusButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
