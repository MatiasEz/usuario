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
        
        let social = information ["redes"] as! [AnyHashable: Any]
        
        let item = social ["facebook"] as! [AnyHashable: Any]
        let string = item ["name"] ?? ""
      
      self.socialButton.setTitle("\(string)", for: UIControlState.normal)
        
        let item2 = social ["instagram"] as! [AnyHashable: Any]
        let string2 = item2 ["name"] ?? ""
        self.instagramButton.setTitle("\(string2)", for: UIControlState.normal)
        
        let item3 = social ["twitter"] as! [AnyHashable: Any]
        let string3 = item3 ["name"] ?? ""
        self.twitterButton.setTitle("\(string3)", for: UIControlState.normal)
        
      
        
     
      self.navigationItem.backBarButtonItem?.title = ""
        
        super.viewWillAppear(animated)
        
    }
   
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      
   }
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
   let cell = self.tableView.dequeueReusableCell(withIdentifier: "socialCell")
      return cell!

      
   }

    @IBAction func facebookPress(_ sender: Any) {
        let social = information ["redes"] as! [AnyHashable: Any]
        let item = social ["facebook"] as! [AnyHashable: Any]
      let applink = (item ["applink"] ?? "") as! String
      let canOpenApplink = UIApplication.shared.canOpenURL(URL(string: applink) ?? URL(string:"12312")!);
      let string = (item ["link"] ?? "") as! String
      let canOpen = UIApplication.shared.canOpenURL(URL(string: string)  ?? URL(string:"12312")!);
      if (canOpenApplink) {
         UIApplication.shared.openURL(URL(string: applink)!)
      } else if (canOpen) {
         UIApplication.shared.openURL(URL(string: string)!)
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
