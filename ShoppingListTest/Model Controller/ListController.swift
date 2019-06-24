//
//  ListController.swift
//  ShoppingListTest
//
//  Created by Madison Kaori Shino on 6/23/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    
    //MARK: - Singleton & Source of Truth
    static let sharedInstance = ListController()

    //MARK: - Fetch
    var fetchedResultsController: NSFetchedResultsController<List>
    
    init() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "wasBought", ascending: true)]
        let resultsController: NSFetchedResultsController<List> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.managedObjectContext, sectionNameKeyPath: "wasBought", cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing the fetch request")
        }
    }
    
    //MARK: - Crud Functions
    func addItem(item: String) {
        _ = List(itemName: item, wasBought: false)
        saveToPersistentStore()
    }
    
    func toggleWasBoughtFor(item: List) {
        item.wasBought = !item.wasBought
        saveToPersistentStore()
    }
    
    func removeItem(item: List) {
        CoreDataStack.managedObjectContext.delete(item)
        saveToPersistentStore()
    }
    
    //MARK: - Persistence
    func saveToPersistentStore() {
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("Error Saving to Persistent Store", error.localizedDescription)
        }
    }
    
}
