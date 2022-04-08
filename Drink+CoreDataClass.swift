//
//  Drink+CoreDataClass.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 06/04/22.
//
//

import Foundation
import CoreData

@objc(Drink)
public class Drink: NSManagedObject {
    
    func initializeObject(_ drink: [String:String]){
        
        let name = (drink["name"]) ?? ""
        let ingredients = (drink["ingredients"]) ?? ""
        let directions = (drink["directions"]) ?? ""
        let image = (drink["image"]) ?? ""
        
        self.name = name
        self.ingredients = ingredients
        self.directions = directions
        self.image = image
        
    }

}
