//
//  RedSocial.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 31/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class RedSocial: NSObject {
   
   var title : String
   var applink : String?
   var tag : String
   var link : String
   
   public init(title: String, tag: String, link: String, applink: String? ) {
      self.title = title
      self.tag = tag
      self.link = link
      self.applink = applink

}


}



