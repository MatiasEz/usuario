//
//  GiftViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class GiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
   @IBOutlet weak var tableView: UITableView!
   
   
   
   
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var items : [Gift] = []
    override func viewWillAppear(_ animated: Bool) {
      self.tableView.dataSource = self;
      self.tableView.delegate = self;
      
      super.viewWillAppear(animated)

      self.addSocialNetwork(key: "green")
      self.addSocialNetwork(key: "red")
      self.addSocialNetwork(key: "blue")
      self.addSocialNetwork(key: "gray")
      self.addSocialNetwork(key: "purple")
      self.addSocialNetwork(key: "pink")
      
   }
   
 func addSocialNetwork(key: String) {
   guard let social = information ["gifts"] as? [AnyHashable: Any] else { self.displayError(message:"Aun no hemos preparado los regalos para el anfitrión. Intenta mas tarde.")
      
      
      
      return
   }
      let facebookItem = social [key] as? [String: String]
      if let facebookItem = facebookItem {
         let facebookName = facebookItem ["name"] ?? ""
         let facebookLink = facebookItem ["link"] ?? ""
         let facebookImageUrl = facebookItem ["image_url"] ?? ""
         let facebookCantidad = facebookItem ["amount"] ?? ""
         let gift = Gift(identifier: key, tag: facebookName, link: facebookLink, imageUrl: facebookImageUrl, cantidad: facebookCantidad)
         items.append(gift)
         
         
      }
   }
   
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.items.count;
   }
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "giftCell") as! GiftTableViewCell
      let row : Int = indexPath.row
      let currentItem : Gift = items[row]
      cell.giftLabel.text = currentItem.tag
      cell.giftPriceLabel.text = currentItem.cantidad
      let imageName = currentItem.identifier
      cell.giftImage.image = UIImage(named: currentItem.identifier)
      self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
      switch (currentItem.identifier) {
         
      case "green" :    cell.containerView.layer.borderColor = UIColor.green.cgColor
         break
         
      case "red" :   cell.containerView.layer.borderColor = UIColor.red.cgColor
         break
         
      case "blue" :    cell.containerView.layer.borderColor = UIColor.blue.cgColor
         break
         
         
      case "gray" :  cell.containerView.layer.borderColor = UIColor.gray.cgColor
         break
         
         
      case "purple" :   cell.containerView.layer.borderColor = UIColor.purple.cgColor
         break
         
         
      case "pink" :    cell.containerView.layer.borderColor = UIColor.magenta.cgColor
         break
         
      default:
         break
         
      }
      
      if let url = URL(string: currentItem.imageUrl) {
         
      cell.giftImage.image = nil
      DispatchQueue.global().async {
         let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
         DispatchQueue.main.async {
           
            cell.giftImage.image = UIImage(data: data!)
            cell.giftImage.alpha = 0
            UIView.animate(withDuration: 0.7 , delay: 0, options: .curveEaseOut, animations: {
               
               cell.giftImage.alpha = 1
            }, completion: nil)
            
         }
         }}
      
      return cell

   }
   
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let row : Int = indexPath.row
      let currentItem : Gift = items[row]
      
      
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
