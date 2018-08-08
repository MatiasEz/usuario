//
//  Invitado.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 5/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Invitado: NSObject {
   
   
   var mail : String? = nil
  
   
   
   public init(mail: String? = nil ) {
      self.mail = mail
   }
   public init(map:[String:Any] ) {
      self.mail = map["mail"] as! String?
   }


}
