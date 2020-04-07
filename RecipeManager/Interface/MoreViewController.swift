//
//  MoreViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 17.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

struct MoreItem {
    var title: String
    var target: Selector?
    
    static var useRetardedUnitsKey = "Anton.RecipeManager.useRetardedUnits"
}

class MoreViewController: UITableViewController {
    
    var content: [String: [MoreItem]] = [
        NSLocalizedString("Settings", comment: "") : [MoreItem(title: NSLocalizedString("Use retarded units", comment: ""), target: #selector(useRetardedUnits))]
    ]
    
    @objc func useRetardedUnits() {
        if UserDefaults.standard.bool(forKey: MoreItem.useRetardedUnitsKey) {
            UserDefaults.standard.set(false, forKey: MoreItem.useRetardedUnitsKey)
        } else {
            UserDefaults.standard.set(true, forKey: MoreItem.useRetardedUnitsKey)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
    }
}

extension MoreViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content[Array(content.keys)[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(content.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = self.content[Array(self.content.keys)[indexPath.section]]?[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)
        
        cell.textLabel?.text = content?.title
        let retarded = UserDefaults.standard.bool(forKey: MoreItem.useRetardedUnitsKey)
        cell.detailTextLabel?.text = NSLocalizedString(retarded ? "ON" : "OFF", comment: "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selector = self.content[Array(self.content.keys)[indexPath.section]]?[indexPath.item].target {
            perform(selector)
        }
    }
}
