//
//  SocialTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 28/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

   @IBOutlet weak var socialButton: UIButton!
   @IBOutlet weak var socialLabel: UILabel!
   @IBOutlet weak var redSocialImage: UIImageView!
  
   
   override func awakeFromNib() {
      
      socialButton.layer.cornerRadius = 20
      socialButton.backgroundColor = .clear
      
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
