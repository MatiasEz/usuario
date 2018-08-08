//
//  InvitationErrorViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 1/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth

class InvitationErrorViewController: UIViewController {

    let userEmail = Auth.auth().currentUser?.email;

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        
        self.descriptionLabel.text = "Para poder acceder a la información del evento debes estar en el listado de mails habilitados para usar la app. Por favor indicale al organizador del evento que agregue tu mail \(userEmail ?? "desconodido") para poder ingresar."
        
        self.backButton.backgroundColor = .clear
        self.backButton.layer.cornerRadius = 20
        self.backButton.layer.borderWidth = 1
        self.backButton.layer.borderColor = UIColor.white.cgColor

        
        
        super.viewDidLoad()

    }

    
    @IBAction func backToHome(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
