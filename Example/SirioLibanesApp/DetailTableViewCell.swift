//
//  DetailTableViewCell.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    @IBOutlet public weak var tituloLabel: UILabel!
   public var timestamp : Int = 1000 {
      
      didSet {
         updateTimer()
      }
   }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView?.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
         self.backgroundImageView.image = nil

        runTimer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func runTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer () {
      let secondsNow = Int (Date().timeIntervalSince1970)
      let totalSeconds = timestamp - secondsNow
      
      let seconds: Int = totalSeconds % 60
      let minutes: Int = (totalSeconds / 60) % 60
      let hours: Int = (totalSeconds / (60 * 60))  % 24
      let days: Int = totalSeconds / (60 * 60 * 24)
      daysLabel.text = "\(String(format: "%02d",days))"
      hourLabel.text = "\(String(format: "%02d",hours))"
      minuteLabel.text = "\(String(format: "%02d",minutes))"
    }

}
