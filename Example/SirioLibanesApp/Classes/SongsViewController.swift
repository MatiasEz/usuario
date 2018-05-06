//
//  SongsViewController.swift
//  SirioLibanesApp_Example
//
//  Created by Federico Bustos Fierro on 2/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias CompletionHandler = ( (_ success:Bool) -> Void )?

    public var information : [AnyHashable: Any] = [:]
    public var pageName : String = ""
    var songs : [[AnyHashable:Any]] = [];
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.backgroundColor = .clear
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.white.cgColor
      self.navigationItem.backBarButtonItem?.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.alpha = 0
        self.descriptionLabel.alpha = 0
        getUserDataAndContinue(completionHandler: nil)
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        let button = sender as! UIButton
        let map = self.songs [button.tag]
        let songTitle = map ["tema"] as! String
        changeCounter(for: songTitle)
    }
    
    func changeCounter(for song : String) {
      var increase = true
      let userId = Auth.auth().currentUser?.uid;
      let songKey = "\(userId ?? "0") + \(pageName) + \(song)"
      let songAlreadyVoted = UserDefaults.standard.bool(forKey: songKey)
      if (songAlreadyVoted) {
         UserDefaults.standard.set(false, forKey: songKey)
         increase = false
      } else {
         UserDefaults.standard.set(true, forKey: songKey)
      }
      
        getUserDataAndContinue { (success) in
            
            var currentMap : [AnyHashable:Any]?
            for map in self.songs {
                let title = map ["tema"] as! String
                if (title == song) {
                    currentMap = map
                }
            }

            if (currentMap == nil) {
                self.displayError(message: "No pudimos registrar tu voto")
                return
            }
            
            var counter = currentMap! ["votos"] as! Int
            if (increase) {
                counter += 1
            } else {
                counter -= 1
            }
            
            self.songs = self.songs.filter { $0 ["tema"] as! String != song}
            let artist = (currentMap! ["artista"] as! String?) ?? "Desconocido"
            let user = (currentMap! ["user"] as! String?) ?? "Desconocido"
            let newMap = ["tema":song,"votos":counter, "artista":artist, "user": user] as [AnyHashable : Any]
            self.songs.append(newMap)
            self.songs = self.songs.sorted(by: self.sorterForSong)
            
            
            self.ref.child("Musica").child(self.pageName).setValue(self.songs)
         
            self.descriptionLabel.text = "Estas son las canciones más votadas"
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }

            if (self.tableView.alpha == 0) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 1
                    self.descriptionLabel.alpha = 1
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               self.tableView.reloadData()
            }
        }
    }
    
    func sorterForSong(this:[AnyHashable:Any], that:[AnyHashable:Any]) -> Bool {
        let monto1 = this ["votos"] as! Int
        let monto2 = that ["votos"] as! Int
        if (monto1 > monto2) {
            return true;
        } else {
            return false;
        }
    }
    
    func getUserDataAndContinue (completionHandler: CompletionHandler) {
        let userEmail = Auth.auth().currentUser?.email;
        
        if (userEmail == nil) {
            self.displayError()
            return;
        }
        
        ref.child("Musica").child(pageName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.songs = [];
            let allInvites = snapshot.value as? [[AnyHashable:Any]] ?? []
            self.songs = allInvites;
            
            if (self.songs.count == 0) {
                self.descriptionLabel.text = "No encontramos canciones propuestas aun"
                UIView.animate(withDuration: 0.3, animations: {
                    self.descriptionLabel.alpha = 1
                })
            } else {
                self.descriptionLabel.text = "Estas son las canciones más votadas"
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 1
                    self.descriptionLabel.alpha = 1
                })
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  self.tableView.reloadData()
               }
            }
            
            if (completionHandler != nil) {
                completionHandler! (true)
            }
            
            PKHUD.sharedHUD.hide()
            
            
        }) { (error) in
            self.displayError()
        }
    }    
    
    @IBAction func proposeNewSong(_ sender: Any) {
        
        let alertController = UIAlertController(title: "¿Qué canción quieres proponer?", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField?
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar el nombre de la canción")
            return
         }
            self.chooseArtist((firstTextField?.text)!);

        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nombre del tema"
        }
      
         alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
   
   func chooseArtist (_ song : String){
      
      let alertController = UIAlertController(title: "¿Quien es el autor de esta canción?", message: "", preferredStyle: .alert)
      
      let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
         alert -> Void in
         
         let firstTextField = alertController.textFields![0] as UITextField?
         
         if ((firstTextField?.text)!.isEmpty) {
            self.displayError(message: "Debes ingresar el nombre del artista")
            return
         }
         
         self.sendSong(song: song, artist: (firstTextField?.text)!);
         
      })
      
      let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
         (action : UIAlertAction!) -> Void in
         
      })
      
      alertController.addTextField { (textField : UITextField!) -> Void in
         textField.placeholder = "Nombre del artista"
      }
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
   }
    
    func sendSong (song : String, artist : String)
    {
        if (song.isEmpty) {
            self.displayError(message:"El campo de ingreso esta vacio");
            return
        }
      
      guard let firstName = UserDefaults.standard.string(forKey: "firstNameKey"),
         let lastName = UserDefaults.standard.string(forKey: "lastNameKey") else {
         displayError(message: "Por favor cierra sesión y vuelve a iniciar")
         return
      }
        
        getUserDataAndContinue { (success) in
         let map = ["tema":song,"artista":artist,"votos":0, "user":"\(firstName) \(lastName)"] as [AnyHashable : Any]
         self.songs.append(map)
         self.songs = self.songs.sorted(by: self.sorterForSong)
         self.ref.child("Musica").child(self.pageName).setValue(self.songs)
         self.descriptionLabel.text = "Estas son las canciones más votadas"
         DispatchQueue.main.async {
            self.tableView.reloadData()
            if (self.tableView.alpha == 0) {
               UIView.animate(withDuration: 0.3, animations: {
                  self.tableView.alpha = 1
                  self.descriptionLabel.alpha = 1
               })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               self.tableView.reloadData()
            }
         }

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = self.songs [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongTableViewCell
        cell.tag = indexPath.row
      let songTitle = song ["tema"] as! String?
        cell.songLabel.text = songTitle
      
      let userId = Auth.auth().currentUser?.uid;
      let songKey = "\(userId ?? "0") + \(pageName) + \(songTitle ?? "")"
      let songAlreadyVoted = UserDefaults.standard.bool(forKey: songKey)
      if (songAlreadyVoted) {
         cell.heartImage.image = UIImage(named:"heartfull")
         cell.counterLabel.textColor = UIColor.white
      } else {
         cell.heartImage.image = UIImage(named:"heartvoid")
         cell.counterLabel.textColor = UIColor.red
      }
      
      
         let artist = (song ["artista"] as! String?) ?? "Desconocido"
        cell.artistLabel.text = artist
        let number = song ["votos"] as? Int
        cell.counterLabel.text = "\(number ?? 0)"
      
      let rankingNumber = indexPath.row + 1
      let rankingString = "\(rankingNumber)"
      cell.rankingLabel.text = rankingString
      
      if (indexPath.row > 2) {
         cell.rankingLabel.isHidden = false
         cell.rankingImage.isHidden = true
      } else {
         cell.rankingLabel.isHidden = true
         cell.rankingImage.isHidden = false
      }
      
      switch (indexPath.row) {
            case 0:
               cell.rankingImage.image = UIImage(named:"ranking1");
               break;
            case 1:
               cell.rankingImage.image = UIImage(named:"ranking2");
               break;
            case 2:
               cell.rankingImage.image = UIImage(named:"ranking3");
               break;
            default:
               break;
      }
      
      
      
      let userName = song ["user"] as? String
      cell.userLabel.text = userName ?? "Sin usuario"
      
      
      
        return cell
    }
   
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
      {
         return 80.0;//Choose your custom row height
      }
   
    func displayError (message: String = "No pudimos obtener las canciones, intenta mas tarde.") {
        PKHUD.sharedHUD.hide()
        let alert = UIAlertController(title: "¡Hubo un error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "De acuerdo", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
