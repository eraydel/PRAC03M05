//
//  Drink+CoreDataProperties.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 06/04/22.
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var directions: String?
    @NSManaged public var image: String?

}

extension Drink : Identifiable {

}
