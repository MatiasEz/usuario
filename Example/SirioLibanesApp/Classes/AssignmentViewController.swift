//
//  AssignmentViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class AssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var assignmentTable: UITableView!
    
    var myFriends : [[AnyHashable:Any]] = [];
    var myTableName : String = "";
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        self.assignmentTable.dataSource = self;
        self.assignmentTable.delegate = self;
        self.assignmentTable.alpha = 0
        self.descriptionLabel.alpha = 0
      self.navigationItem.backBarButtonItem?.title = ""
        getUserDataAndContinue()
    }
    
    
    func getUserDataAndContinue () {
        let userEmail = Auth.auth().currentUser?.email;
        
        if (userEmail == nil) {
            self.displayError()
            return;
        }
        
        let unwUserEmail = userEmail!
        
        ref.child("Asignaciones").child(pageName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.myFriends = [];
            let userAssignmentData = snapshot.value as? [AnyHashable : Any] ?? [:]
            for key in userAssignmentData.keys {
                let allInvites : [[AnyHashable:Any]] = userAssignmentData [key] as! [[AnyHashable:Any]]
                
                for invite in allInvites {
                    let invitedMail = invite ["mail"] as! String
                    if (invitedMail == unwUserEmail) {
                        self.myTableName = key as! String
                        self.myFriends  = allInvites.filter{$0 ["mail"] as! String != invitedMail}
                    }
                }
            }
            if (self.myTableName.isEmpty) {
                self.assignmentLabel.text = "No encontramos tu asignación"
            } else {
               let newString = self.myTableName.replacingOccurrences(of: "Mesa ", with: "")
                self.assignmentLabel.text = "Tu mesa es la " + newString
                self.assignmentTable.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.assignmentTable.alpha = 1
                    self.descriptionLabel.alpha = 1
                })
            }

            
            
            PKHUD.sharedHUD.hide()
            
            
        }) { (error) in
            self.displayError()
        }
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFriends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = self.myFriends [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! AssignmentTableViewCell
        cell.friendLabel.text = friend ["nombre"] as! String?
        return cell
    }
    
    func displayError (message: String = "No pudimos cambiar tu estado de confirmacion, intenta mas tarde.") {
        PKHUD.sharedHUD.hide()
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "social" {
            let viewController: SocialViewController = segue.destination as! SocialViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
        if segue.identifier == "songs" {
            let viewController: SongsViewController = segue.destination as! SongsViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
    }
    
}
