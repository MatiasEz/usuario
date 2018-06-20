//
//  SocialViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
   @IBOutlet weak var tableView: UITableView!
   
   
   
   
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var items : [RedSocial] = []
    override func viewWillAppear(_ animated: Bool) {
      self.tableView.dataSource = self;
      self.tableView.delegate = self;
      
      super.viewWillAppear(animated)

      self.addSocialNetwork(key: "facebook")
      self.addSocialNetwork(key: "twitter")
      self.addSocialNetwork(key: "instagram")
      self.addSocialNetwork(key: "webpage")
      self.addSocialNetwork(key: "snapchat")
      self.addSocialNetwork(key: "youtube")
      
   }
   
 func addSocialNetwork(key: String) {
      let social = information ["redes"] as! [AnyHashable: Any]
      let facebookItem = social [key] as? [String: String]
      if let facebookItem = facebookItem {
         let facebookName = facebookItem ["name"] ?? ""
         let facebookLink = facebookItem ["link"] ?? ""
         let redSocial = RedSocial(identifier: key, tag: facebookName, link: facebookLink)
         items.append(redSocial)
         
         
      }
   }
   
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.items.count;
   }
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let facebookColour = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
      let instagramColour = UIColor(red:0.91, green:0.35, blue:0.31, alpha:1.0)
      let twitterColour = UIColor(red:0.00, green:0.67, blue:0.93, alpha:1.0)
      let snapchatColour =  UIColor(red:1.00, green:1.00, blue:0.21, alpha:1.0)
      let webPageColour = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
      let youtubeColour = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
      
      
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "socialCell") as! SocialTableViewCell
      let row : Int = indexPath.row
      let currentItem : RedSocial = items[row]
      cell.socialLabel.text = currentItem.tag
      let imageName = currentItem.identifier
      cell.redSocialImage.image = UIImage(named: currentItem.identifier)
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
      switch (currentItem.identifier) {
      
      case "facebook" :    cell.containerView.layer.borderColor = facebookColour.cgColor
      break
      
      case "instagram" :   cell.containerView.layer.borderColor = instagramColour.cgColor
      
         break
      
      
      case "twitter" :    cell.containerView.layer.borderColor = twitterColour.cgColor
      break
      
      
      case "snapchat" :  cell.containerView.layer.borderColor = snapchatColour.cgColor
      break
      
      
      case "youtube" :   cell.containerView.layer.borderColor = youtubeColour.cgColor
      break
      
      
      case "webpage" :    cell.containerView.layer.borderColor = webPageColour.cgColor
      break
      
      default:
      break
      
      }
      
      return cell

   }
   
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let row : Int = indexPath.row
      let currentItem : RedSocial = items[row]
      
      let canOpen = UIApplication.shared.canOpenURL(URL(string: currentItem.link)  ?? URL(string:"12312")!);
      if (canOpen) {
         UIApplication.shared.openURL(URL(string: currentItem.link)!)
      } else {
         displayError()
      }
    }
    
    
    
   
    func displayError (message: String = "No acceder a este link, intenta buscando desde el navegador.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

