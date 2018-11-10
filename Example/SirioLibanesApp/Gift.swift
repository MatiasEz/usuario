//
//  RedSocial.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 31/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Gift: NSObject {
   
   var identifier : String
   var tag : String
   var link : String
   var imageUrl : String
   var cantidad : String
   
   public init(identifier: String, tag: String, link: String, imageUrl: String, cantidad: String) {
      self.identifier = identifier
      self.tag = tag
      self.link = link
      self.imageUrl = imageUrl
      self.cantidad = cantidad
   }
}



