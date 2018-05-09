//
//  HomeViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var ref: DatabaseReference!
    var userItemList : [String] = []
    var allEvents : [AnyHashable : Any] = [:]
    var userEvents : [AnyHashable : Any] = [:]
    var firstTime : Bool = true
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underline: UIView!
    
    override func viewDidLoad() {
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.cgColor
        
        ref = Database.database().reference()
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated:false);
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyState.alpha = 0;
        self.tableView.alpha = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
      self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        if (backViewController() is RegisterViewController && firstTime) {
            updateViewWithCurrentInformation()
            firstTime = false;
            return
        }
        
        self.tableView.backgroundColor = UIColor.clear
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        getUserDataAndContinue()
    }
    
    func backViewController () -> UIViewController?
    {
        let numberOfViewControllers = self.navigationController?.viewControllers.count ?? 0;
        if (numberOfViewControllers < 2) {
            return nil;
        } else {
            return self.navigationController?.viewControllers [numberOfViewControllers - 2];
        }
    }
    
    func getUserDataAndContinue () {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.displayError(message: "Hubo un problema con tu usuario, por favor deslogueate y vuelve a empezar")
            return;
        }
      

      ref.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
         
         guard let userMap = snapshot.value as? [AnyHashable : Any] else {
            return
         }
         
         let firstName = userMap ["nombre"] as? String?
         let lastName = userMap ["apellido"] as? String?
         let nickname = userMap ["nickname"] as? String?
         
         
         if (nickname == nil && firstName == nil && lastName == nil ) {
            self.displayError(message: "Hubo un problema con tu cuenta, por favor deslogueate y vuelve a empezar")
            return
         }

         UserDefaults.standard.set(firstName!, forKey: "firstNameKey")
         UserDefaults.standard.set(lastName!, forKey: "lastNameKey")
         UserDefaults.standard.set(nickname!, forKey: "nicknameKey")
      }) { (error) in
         self.displayError(message: "Hubo un problema obteniendo tu usuario, por favor deslogueate y vuelve a empezar")
         return
      }
        
        let unwUserId = userId
        
        ref.child("Users").child(unwUserId).child("eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userEventData = snapshot.value as? [AnyHashable : Any]
            if let unwEventData = userEventData {
                print (unwEventData.description)
                self.userItemList = Array(unwEventData.keys) as? [String] ?? [];
               if (self.userItemList.count == 0) {
                  self.updateViewWithCurrentInformation()
                  return
               }
               
                self.getEventsDataAndContinue()
            } else {
                self.updateViewWithCurrentInformation()
            }
        }) { (error) in
            self.displayError(message: "Hubo un problema obteniendo los eventos, por favor deslogueate y vuelve a empezar")
            return
        }
    }
    
    func getEventsDataAndContinue () {
        ref.child("Eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let eventData = snapshot.value as? NSDictionary!
            if let unwEventData = eventData {
               self.allEvents = unwEventData as? [AnyHashable : Any] ?? [:];
                self.filterUserEvents()
            } else {
               self.displayError(message: "Hubo un problema asociando tus eventos, por favor deslogueate y vuelve a empezar")
               return
            }
        }) { (error) in
         self.displayError(message: "Hubo un problema obteniendo tus eventos, por favor deslogueate y vuelve a empezar")
         return
        }
    }
    
    func filterUserEvents () {
        var newDictionary = [:] as [AnyHashable : Any]
      var array : [String] = []
        for key in self.userItemList {
            var item = self.allEvents [key]
            if (item != nil) {
               newDictionary [key] = item;
               array.append(key)
            }
        }
        self.userItemList = array
        self.userEvents = newDictionary;
        self.updateViewWithCurrentInformation()
    }
    
    func updateViewWithCurrentInformation () {
        
        self.tableView.alpha = 0;
        self.emptyState.alpha = 0;
        self.underline.alpha = 0;
        self.titleLabel.alpha = 0;
        self.tableView.tableFooterView = nil

        let visibleView = (self.userItemList.count > 0) ? self.tableView as UIView : self.emptyState as UIView
        UIView.animate(withDuration: 0.3, animations: {
            visibleView.alpha = 1
        })
        
        
        if (self.userItemList.count > 0) {
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
            self.underline.alpha = 1
            self.titleLabel.alpha = 1
        }
        
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userEvents.keys.count;
    }
        
    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        let key = self.userItemList [button.tag]
      let map = self.userEvents [key] as? [AnyHashable : Any] ?? [:]
        self.information = map
        self.pageName = key
        self.performSegue(withIdentifier: "social", sender: self)
    }
    
    @IBAction func todayButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        let key = self.userItemList [button.tag]
      let map = self.userEvents [key] as? [AnyHashable : Any] ?? [:]
        self.information = map
        self.pageName = key
        self.performSegue(withIdentifier: "today", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.userItemList [indexPath.row]
      let map = self.userEvents [key] as? [AnyHashable : Any] ?? [:]
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        cell.tag = indexPath.row
        cell.asociatedDictionary = map
        cell.titlecustomLabel.text = map ["titulo"] as! String?
        cell.descriptioncustomLabel.text = map ["descripcion"] as! String?
      let date = Date(timeIntervalSince1970: TimeInterval(map ["timestamp"] as! Int))
      let dayTimePeriodFormatter = DateFormatter()
      dayTimePeriodFormatter.dateFormat = "dd-MM-yy"
      
      let dateString = dayTimePeriodFormatter.string(from: date)
        cell.dateLabel.text = dateString as! String?
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.userItemList [indexPath.row]
        let map = self.userEvents [key] as! [AnyHashable : Any]
        self.information = map
        self.pageName = key
        self.goToDetailScreen()
    }
    
    func goToDetailScreen ()
    {
        self.performSegue(withIdentifier: "detailEvent", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro de que desea cerrar su sesión?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "logout", sender: self)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
      
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError (message: String = "No pudimos obtener tus eventos, intenta mas tarde.") {
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        PKHUD.sharedHUD.hide(afterDelay: 0.3) { success in
            // Completion Handler
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailEvent" {
            let viewController: DetailViewController = segue.destination as! DetailViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
         }
        
        if segue.identifier == "social" {
            let viewController: SocialViewController = segue.destination as! SocialViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
        
        if segue.identifier == "today" {
            let viewController: AssignmentViewController = segue.destination as! AssignmentViewController
            viewController.information = self.information
            viewController.pageName = self.pageName
        }
    }


}
