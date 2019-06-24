//
//  ListTableViewCell.swift
//  ShoppingListTest
//
//  Created by Madison Kaori Shino on 6/23/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    weak var cellDelegate: ListTableViewCellDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    //MARK: - Actions
    @IBAction func checkboxButtonTapped(item: List) {
        cellDelegate?.checkboxButtonTapped(self)
    }
    
    //MARK: Functions
    func updateButton(_ wasBought: Bool) {
        switch wasBought {
        case true:
            checkboxButton.setImage(UIImage(named: "checked"), for: .normal)
        case false:
            checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    func update(withItem item: List) {
        itemLabel.text = item.itemName
        updateButton(item.wasBought)
    }
}

//MARK: - Protocol
protocol AddItemAlertDelegate {
    func addNewItemAlert()
}

protocol ListTableViewCellDelegate: class {
    func checkboxButtonTapped(_ sender: ListTableViewCell)
}
