//
//  NewRecipeBookViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeBookViewController: UIViewController {
    
    static var detailsChangedKey = Notification.Name("NewRecipeBookViewController.detailChanged")
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var content: [ContentType] = [.name, .appearence]
    
    var editingRecipeBook: RecipeBook?
    
    var recipeBookColor: RecipeBook.Color = RecipeBook.Color.randomColor() 
    var recipeBookGlyph: UIImage? = UIImage(named: "cookingHat")
    var recipeBookIcon: UIImage? { return recipeBookIcon(recipeBook: recipeBookColor.icon512, glyph: recipeBookGlyph) }
    var recipeBookName: String = NSLocalizedString("My Recipes", comment: "")
    
    override func viewDidLoad() {
        setUpViews()
        fillData()
    }
    
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        tableView.register(NewRecipeBookIconCell.self, forCellReuseIdentifier: "NewRecipeBookIconCell")
        tableView.register(NewRecipeBookTintColorCell.self, forCellReuseIdentifier: "NewRecipeBookTintColorCell")
        tableView.register(NewRecipeBookNameCell.self, forCellReuseIdentifier: "NewRecipeBookNameCell")
        tableView.register(NewRecipeBookGlyphCell.self, forCellReuseIdentifier: "NewRecipeBookGlyphCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewRecipeBookDeleteCell")
    }
    
    func fillData() {
        if let _ = editingRecipeBook {
            content.append(.delete)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleSaveButton(_ sender: Any) {
        if recipeBookName != "" {
            let recipeBook = RecipeBook(context: PersistenceService.context)
            recipeBook.name = recipeBookName
            recipeBook.appearenceString = recipeBookColor.key
            recipeBook.icon = recipeBookIcon
            recipeBook.recordName = UUID().uuidString
            recipeBooks.append(recipeBook)
            PersistenceService.saveContext()
            dismiss(animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Name missing", message: "Please enter a name for your new recipe book.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? NewRecipeBookNameCell {
                    cell.textField.becomeFirstResponder()
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let info = notification.userInfo
        
        if let keyboardRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var contentInset = tableView.contentInset
            contentInset.bottom = keyboardRect.size.height + 12
            tableView.contentInset = contentInset
            
            var indicatorInset = tableView.verticalScrollIndicatorInsets
            indicatorInset.bottom = keyboardRect.size.height + 12
            tableView.scrollIndicatorInsets = indicatorInset
        }
    }
    
    @objc func keyboardWillHide() {
        var contentInset = tableView.contentInset
        contentInset.bottom = 0
        tableView.contentInset = contentInset

        var indicatorInset = tableView.verticalScrollIndicatorInsets
        indicatorInset.bottom = 0
        tableView.scrollIndicatorInsets = indicatorInset
    }
    
    func recipeBookIcon(recipeBook: UIImage?, glyph: UIImage?) -> UIImage? {
        guard let recipeBook = recipeBook else { return nil }
        guard let glyph = glyph else { return recipeBook }

        let size = CGSize(width: 512, height: 512)
        UIGraphicsBeginImageContext(size)

        let recipeRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        recipeBook.draw(in: recipeRect)

        let glypgEdge = size.width * 0.36
        let glyphHeight = (glyph.size.height > glyph.size.width) ? glypgEdge : glypgEdge * (glyph.size.height / glyph.size.width)
        let glyphWidth = (glyph.size.width > glyph.size.height) ? glypgEdge : glypgEdge * (glyph.size.width / glyph.size.height)
        let glyphX = ((size.width - glyphWidth) / 2) + 28
        let glyphY = 160 - (glyphHeight / 2)
        let glyphRect = CGRect(x: glyphX, y: glyphY, width: glyphWidth, height: glyphHeight)
        glyph.draw(in: glyphRect, blendMode: .normal, alpha: 1)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    enum ContentType {
        case appearence
        case name
        case delete
    }
}

extension NewRecipeBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch content[section] {
        case .appearence: return 3
        case .name: return 1
        case .delete: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = content[indexPath.section]
        switch c {
        case .appearence:
            if indexPath.item == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeBookIconCell", for: indexPath) as! NewRecipeBookIconCell
                cell._target = self
                cell.setUpViews()
                cell.fillData()
                return cell
                
            } else if indexPath.item == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeBookTintColorCell", for: indexPath) as! NewRecipeBookTintColorCell
                cell._target = self
                cell.setUpViews()
                cell.fillData()
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeBookGlyphCell", for: indexPath) as! NewRecipeBookGlyphCell
                cell._target = self
                cell.setUpViews()
                cell.fillData()
                return cell
            }
            
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeBookNameCell", for: indexPath) as! NewRecipeBookNameCell
            cell._target = self
            cell.setUpViews()
            cell.fillData()
            return cell
            
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewRecipeBookDeleteCell", for: indexPath)
            cell.selectionStyle = .default
            cell.textLabel?.text = NSLocalizedString("Delete Recipe Book", comment: "")
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let c = content[indexPath.section]
        switch c {
        case .appearence:
            if indexPath.item == 0 {
                return 200
            } else {
                return 110
            }
            
        case .name: return 65
        case .delete: return 65
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch content[section] {
        case .appearence: return "Appearence"
        case .name: return "Name"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = content[indexPath.section]
        switch c {

        case .delete:
            guard let recipeBook = editingRecipeBook else { break }
            let alert = UIAlertController(title: NSLocalizedString("Delete Recipe Book", comment: ""), message: NSLocalizedString("Are you sure you want to delete this recipe book? It will also be removed from the cloud.", comment: ""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
                recipeBooks.removeAll(where: {$0.recordName == recipeBook.recordName})
//                CloudKitService.deleteRecipeFromCloud(recipe: recipeBook) { (success, recordID) in
//                    if success {
//                        print("Successfully deleted Recipe from Cloud: \(recordID?.recordName ?? "")")
//                        PersistenceService.persistentContainer.viewContext.delete(recipe)
//                        PersistenceService.saveContext()
//                    }
//                }
                PersistenceService.persistentContainer.viewContext.delete(recipeBook)
                PersistenceService.saveContext()
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: RecipeBook.recipeBooksUpdatedKey, object: nil)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
}


