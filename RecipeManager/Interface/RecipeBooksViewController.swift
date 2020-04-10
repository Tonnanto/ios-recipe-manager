//
//  RecipeBooksViewController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 09.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeBooksViewController: UIViewController {
    
    static var firstRecipeBookCreatedKey: String = "RecipeBooksViewController.firstRecipeBookCreatedKey"
    
    @IBOutlet weak var allRecipesButton: UIButton!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var selectedIndexPath: IndexPath!
    var generator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        setUpViews()
        fillData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(fillData), name: RecipeBook.recipeBooksUpdatedKey, object: nil)
        
        allRecipesButton.layer.cornerRadius = 8
        allRecipesButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        allRecipesButton.layer.shadowColor = UIColor.black.cgColor
        allRecipesButton.layer.shadowRadius = 8
        allRecipesButton.layer.shadowOpacity = 0.3
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecipeBooksCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeBooksCollectionViewCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 64)
        }
        
        pageControl.numberOfPages = recipeBooks.count
        pageControl.pageIndicatorTintColor = UIColor(named: "heavyTint")?.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor(named: "heavyTint")
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
    }
    
    @objc func fillData() {
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let newRecipe = itemCount != 0 && itemCount != recipeBooks.count
        
        collectionView.reloadData()
        updatePageControl()
        
        if newRecipe { collectionView.scrollToItem(at: IndexPath(item: recipeBooks.count - 1, section: 0), at: .centeredHorizontally, animated: true)}
        
        if !UserDefaults.standard.bool(forKey: RecipeBooksViewController.firstRecipeBookCreatedKey) {
            
        }
    }
    
    func updatePageControl() {
        pageControl.numberOfPages = recipeBooks.count
        let center = view.convert(self.collectionView.center, to: self.collectionView)
        if let index = collectionView.indexPathForItem(at: center)?.item, index != pageControl.currentPage {
            generator.selectionChanged()
            pageControl.currentPage = index
        }
    }
    
    @IBAction func handleAllRecipeButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipesViewController") as? RecipesViewController else { return }
        vc.recipeBook = nil
        show(vc, sender: self)
    }
}

extension RecipeBooksViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeBook = recipeBooks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeBooksCollectionViewCell", for: indexPath) as! RecipeBooksCollectionViewCell
        cell._target = self
        cell.fillData(recipeBook: recipeBook)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 128
        let height = collectionView.frame.height - 64
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeBook = recipeBooks[indexPath.item]
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipesViewController") as? RecipesViewController else { return }
        vc.recipeBook = recipeBook
        show(vc, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl()
    }
}
//
//
//class AllRecipesCell: BaseCollectionViewCell {
//    lazy var iconView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFit
//        return iv
//    }()
//
//    lazy var label: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        label.text = NSLocalizedString("All Recipes", comment: "")
//        label.textColor = .secondaryLabel
//        return label
//    }()
//
//    override func setUpViews() {
//        contentView.layer.cornerRadius = 8
//        contentView.backgroundColor = .secondarySystemBackground
//        contentView.addSubview(iconView)
//        contentView.addSubview(label)
//
//        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
//        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
//        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
//
//        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        label.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 12).isActive = true
//        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
//
//    }
//}
