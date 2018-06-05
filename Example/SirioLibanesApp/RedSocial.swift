//
//  RedSocial.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 31/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class RedSocial: NSObject {
   
   var identifier : String
   var tag : String
   var link : String
   
   public init(identifier: String, tag: String, link: String) {
      self.identifier = identifier
      self.tag = tag
      self.link = link
   }
}



