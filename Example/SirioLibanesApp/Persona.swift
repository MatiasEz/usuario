//
//  Persona.swift
//  SirioLibanesApp_Example
//
//  Created by Federicuelo on 12/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Persona: NSObject {
   
   var peso : Int
   var altura : Int
   var tieneOjos : Bool = true
   var nombre : String
   var genero : String
   var velocidad : Int
   var esHomosexual : Bool?
   
   
   public init (nombre: String, altura : Int, genero : String, velocidad : Int, peso : Int) {
      self.nombre = nombre
      self.altura = altura
      self.genero = genero
      self.peso = peso
      self.velocidad = velocidad
   }
   
}

