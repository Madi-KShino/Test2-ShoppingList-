//
//  List+Convenience.swift
//  ShoppingListTest
//
//  Created by Madison Kaori Shino on 6/23/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CoreData

extension List {
    @discardableResult
    convenience init(itemName: String, wasBought: Bool, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        self.init(context: context)
        self.itemName = itemName
        self.wasBought = false
    }
}
