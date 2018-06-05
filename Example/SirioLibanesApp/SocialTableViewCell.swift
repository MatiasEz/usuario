//
//  SocialTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 28/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

   @IBOutlet weak var socialLabel: UILabel!
   @IBOutlet weak var redSocialImage: UIImageView!
   @IBOutlet weak var containerView: UIView!
   
   
   override func awakeFromNib() {
      
      self.containerView.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
      self.containerView.layer.cornerRadius = 20
      self.containerView.layer.borderWidth = 1
      self.containerView.layer.borderColor = UIColor.blue.cgColor

      super.awakeFromNib()
        // Initialization code
    }
}
