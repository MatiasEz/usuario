//
//  SocialTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 28/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

   var facebookColour = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
   var instagramColour = UIColor(red:0.91, green:0.35, blue:0.31, alpha:1.0)
   var twitterColour = UIColor(red:0.00, green:0.67, blue:0.93, alpha:1.0)
   var snapchatColour =  UIColor(red:1.00, green:1.00, blue:0.21, alpha:1.0)
   var webPageColour = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
   var youtubeColour = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
   
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

