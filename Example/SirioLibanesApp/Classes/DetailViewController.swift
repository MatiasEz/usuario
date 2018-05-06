//
//  DetailViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
   @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
   var detailCell : DetailTableViewCell?
    var ref: DatabaseReference!
   
   let kRed = UIColor(red: 206.0/255.0, green: 46.0/255.0, blue: 35.0/255.0, alpha: 1.0)
   let kGreen = UIColor(red: 3.0/255.0, green: 178.0/255.0, blue: 32.0/255.0, alpha: 1.0)
   let kOrange = UIColor(red: 242.0/255.0, green: 117.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    @IBAction func assistPressed(_ sender: Any) {
        assignUserToEvent(state:"confirmado")
    }
    @IBAction func maybePressed(_ sender: Any) {
         assignUserToEvent(state:"quizas")
    }
    
    @IBAction func wontAssistPressed(_ sender: Any) {
         assignUserToEvent(state:"cancelado")
    }
    func assignUserToEvent (state: String = "indeterminado")
    {
        let userEmail = Auth.auth().currentUser?.email;
        if let unwrappedUserEmail = userEmail {
         guard let token = UserDefaults.standard.string(forKey: "nicknameKey") else {
            displayError(message: "Por favor cierra sesión y vuelve a iniciar")
            return
         }
            
            ref.child("Eventos").child(self.pageName).child("invitados").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userEventData = snapshot.value as? [AnyHashable : Any]
                if var unwEventData = userEventData {
                    print (unwEventData.description)
                    unwEventData [token] = state
                    self.ref.child("Eventos").child(self.pageName).child("invitados").setValue(unwEventData)
                } else {
                    self.ref.child("Eventos").child(self.pageName).child("invitados").setValue([token:state])
                }
                
                self.setupButtonWithString(state)
                
            }) { (error) in
                self.displayError()
            }
            
        } else {
            print("something went wrong")
        }
    }
    
    func getUserState ()
    {
        let userEmail = Auth.auth().currentUser?.email;
        if let unwrappedUserEmail = userEmail {
         guard let token = UserDefaults.standard.string(forKey: "nicknameKey") else {
            displayError(message: "Por favor cierra sesión y vuelve a iniciar")
            return
         }
            
            ref.child("Eventos").child(pageName).child("invitados").child(token).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                
                let serverCurrentState = snapshot.value as? String;
                if let unwServerCurrentState = serverCurrentState {
                    self.setupButtonWithString(unwServerCurrentState)
                }
                
                
            }) { (error) in
                self.displayError()
            }
            
        } else {
            print("something went wrong")
        }
    }
    
    func setupButtonWithString (_ key : String)
    {
        if (key == "confirmado") {

         self.confirmButton.backgroundColor = kGreen
         self.maybeButton.backgroundColor = UIColor.clear
         self.cancelButton.backgroundColor = UIColor.clear
         
            UIView.animate(withDuration: 0.3, animations: {
               self.confirmButton.alpha = 1
               self.maybeButton.alpha = 1
               self.cancelButton.alpha = 1
            })
        }
        
        if (key == "indeterminado" || key == "cancelado") {


         self.confirmButton.backgroundColor = UIColor.clear
         self.maybeButton.backgroundColor = UIColor.clear
         self.cancelButton.backgroundColor = kRed
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmButton.alpha = 1
               self.maybeButton.alpha = 1
               self.cancelButton.alpha = 1
            })
        }
      
      if (key == "quizas") {
         self.confirmButton.backgroundColor = UIColor.clear
         self.maybeButton.backgroundColor = kOrange
         self.cancelButton.backgroundColor = UIColor.clear
         UIView.animate(withDuration: 0.3, animations: {
            self.confirmButton.alpha = 1
            self.maybeButton.alpha = 1
            self.cancelButton.alpha = 1
         })
      }
        
    }
    @IBAction func goToPlace(_ sender: Any) {
      let string = self.information ["lugar"] as! String
      let canOpen = UIApplication.shared.canOpenURL(URL(string: string)!);
      if (canOpen) {
         UIApplication.shared.openURL(URL(string: string)!)
      } else {
         displayError()
      }
    }
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        oneButton.backgroundColor = .clear
        oneButton.layer.cornerRadius = 20
        oneButton.layer.borderWidth = 1
        oneButton.layer.borderColor = UIColor.white.cgColor
        
        twoButton.backgroundColor = .clear
        twoButton.layer.cornerRadius = 20
        twoButton.layer.borderWidth = 1
        twoButton.layer.borderColor = UIColor.white.cgColor
        
        threeButton.backgroundColor = .clear
        threeButton.layer.cornerRadius = 20
        threeButton.layer.borderWidth = 1
        threeButton.layer.borderColor = UIColor.white.cgColor
      
      fourButton.backgroundColor = .clear
      fourButton.layer.cornerRadius = 20
      fourButton.layer.borderWidth = 1
      fourButton.layer.borderColor = UIColor.white.cgColor
        
        confirmButton.backgroundColor = .clear
        confirmButton.layer.cornerRadius = 20
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = kGreen.cgColor
      
      maybeButton.backgroundColor = .clear
      maybeButton.layer.cornerRadius = 20
      maybeButton.layer.borderWidth = 1
      maybeButton.layer.borderColor = kOrange.cgColor
      
      cancelButton.backgroundColor = .clear
      cancelButton.layer.cornerRadius = 20
      cancelButton.layer.borderWidth = 1
      cancelButton.layer.borderColor = kRed.cgColor
      
      self.navigationItem.backBarButtonItem?.title = ""
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let habilitado = self.information ["habilitada"] as! Bool? ?? false
        self.confirmButton.alpha = 0;
      self.maybeButton.alpha = 0;
      self.cancelButton.alpha = 0;
        getUserState ()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width * 2.0 / 3.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        cell.timestamp = self.information ["timestamp"] as! Int? ?? 0
      self.detailCell = cell
      if let url = URL(string: self.information ["foto"] as! String) {
         downloadImage(url: url)
      }
        return cell
    }
   
   func downloadImage(url: URL) {
      print("Download Started")
      getDataFromUrl(url: url) { data, response, error in
         guard let data = data, error == nil else { return }
         print(response?.suggestedFilename ?? url.lastPathComponent)
         print("Download Finished")
         DispatchQueue.main.async() {
            self.detailCell?.backgroundImageView.image = UIImage(data: data)
         }
      }
   }
   
   func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url) { data, response, error in
         completion(data, response, error)
         }.resume()
   }
    
    @IBAction func myTableAction(_ sender: Any) {
        
        
        let habilitado = self.information ["habilitada"] as! Bool? ?? false
        if (habilitado) {
            self.performSegue(withIdentifier: "today", sender: self)
        } else {
            let alert = UIAlertController(title: "Asignación no disponible", message: "Todavía no se han cerrado las asignaciones de mesa. Vuelve a revisar este segmento en una fecha más próxima al evento.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func displayError (message: String = "No pudimos cambiar tu estado de confirmacion, intenta mas tarde.") {
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
        
        if segue.identifier == "today" {
            let viewController: AssignmentViewController = segue.destination as! AssignmentViewController
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
