//
//  ListTableViewController.swift
//  ShoppingListTest
//
//  Created by Madison Kaori Shino on 6/23/19.
//  Copyright © 2019 Madi S. All rights reserved.
//
import UIKit
import CoreData

class ListTableViewController: UITableViewController, AddItemAlertDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultsController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        addNewItemAlert()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All", message: "Are you sure?!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Wait, No!", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Im Sure", style: .default) { (_) in
            ListController.sharedInstance.deleteAll()
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let item = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.update(withItem: item)
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionIndex = Int(ListController.sharedInstance.fetchedResultsController.sections?[section].name ?? "zero")
        if sectionIndex == 0 {
            return "To Buy"
        } else {
            return "Bought"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let targetItem = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ListController.sharedInstance.removeItem(item: targetItem)
        }
    }
    
    func addNewItemAlert() {
        let alertController = UIAlertController(title: "🗒🖊", message: "Add an item to the shopping list!", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Add a new item here..."
            textField.keyboardType = .default
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let item = alertController.textFields?.first?.text
                else { return }
            ListController.sharedInstance.addItem(item: item)
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Protocol Extensions
extension ListTableViewController: ListTableViewCellDelegate {
    func checkboxButtonTapped(_ sender: ListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let item = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ListController.sharedInstance.toggleWasBoughtFor(item: item)
        sender.update(withItem: item)
    }
}

extension ListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch (type) {
        case NSFetchedResultsChangeType.insert:
            self.tableView?.insertSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        case NSFetchedResultsChangeType.delete:
            self.tableView.deleteSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
