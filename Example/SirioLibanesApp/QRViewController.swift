//
//  QRViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 20/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import QRCode
import FirebaseAuth

class QRViewController: UIViewController {
   
    @IBOutlet weak var qrImage: UIImageView!
    var currentImage : UIImage?
   var currentEvent : String?

    override func viewDidLoad() {
      
      
      let userEmail = Auth.auth().currentUser?.email;
      let qrCode = QRCode(userEmail!)
      self.currentImage = qrCode?.image
      self.qrImage.image = self.currentImage
        super.viewDidLoad()

    }

  
   public func setUpCode (code : String) {
      self.currentEvent = code
   }

}
