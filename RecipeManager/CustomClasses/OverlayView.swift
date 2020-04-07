//
//  OverlayView.swift
//  RecipeManager
//
//  Created by Anton Stamme on 16.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class OverlayView: UIView {
    
    static var headerHeight: CGFloat = 58
    
    var _target: RecipeDetailViewController!
    var recipe: Recipe? { return _target.recipe }
    
    var topAnchorContraint: NSLayoutConstraint?
    var recentConstant: CGFloat = 0
    var bottomPositionConstant: CGFloat = 0
    var middlePositionConstant: CGFloat = 0
    var topPositionConstant: CGFloat = 0
    
    var tabbarHeight: CGFloat = 0

    
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = NSLocalizedString("Ingredients", comment: "")
        return label
    }()
    
    lazy var dragView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var seperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiaryLabel
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(IngredientsCell.self, forCellReuseIdentifier: "IngredientsCell")
        tv.bounces = false
        return tv
    }()
    
    func setUpViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.2
        
        topAnchorContraint = topAnchor.constraint(equalTo: _target.view.bottomAnchor, constant: 0)
        topAnchorContraint?.isActive = true
        
        leftAnchor.constraint(equalTo: _target.view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: _target.view.rightAnchor).isActive = true
        heightAnchor.constraint(equalTo: _target.view.heightAnchor).isActive = true

        tabbarHeight = _target.tabBarController!.tabBar.frame.height
        bottomPositionConstant = -tabbarHeight - OverlayView.headerHeight
        middlePositionConstant = -_target.view.convert(_target.view.frame, to: nil).height * 0.5
        topPositionConstant = -_target.view.convert(_target.view.frame, to: nil).height * 0.85
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        headerView.addGestureRecognizer(tapGesture)
        
        addSubview(headerView)
        addSubview(tableView)
        
        addConstraints([
            NSLayoutConstraint(item: headerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: OverlayView.headerHeight),

            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(dragView)
        headerView.addSubview(seperator)
        
        
        headerView.addConstraints([
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: headerView, attribute: .right, multiplier: 1, constant: -16),
            
            NSLayoutConstraint(item: dragView, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dragView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: dragView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: dragView, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 0.1, constant: 0),
            
            NSLayoutConstraint(item: seperator, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator, attribute: .right, relatedBy: .equal, toItem: headerView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: seperator, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        tableView.bounces = (tableView.contentOffset.y > 20)
    }
    
    func hide(_ bool: Bool) {
        if bool {
            topAnchorContraint?.constant = 0
        } else {
//            _target.view.addSubview(self)
//            self.setUpViews()
            topAnchorContraint?.constant = bottomPositionConstant
        }
        animateLayout {
//            if bool {
//                self._target.view.willRemoveSubview(self)
//                self.removeFromSuperview()
//            }
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let topAnchorContraint = topAnchorContraint else { return }
        
        if topAnchorContraint.constant == bottomPositionConstant {
            topAnchorContraint.constant = middlePositionConstant
        } else if topAnchorContraint.constant == middlePositionConstant {
            topAnchorContraint.constant = bottomPositionConstant
        } else if topAnchorContraint.constant == topPositionConstant {
            topAnchorContraint.constant = middlePositionConstant
        }
        
        animateLayout()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let topAnchorContraint = topAnchorContraint else { return }
        let y = sender.translation(in: _target.view).y
        let v = sender.velocity(in: _target.view).y
        let newConstant = recentConstant + y
        
        switch sender.state {
        case .began:
            recentConstant = topAnchorContraint.constant
        case .changed:
            guard newConstant <= bottomPositionConstant + 8 else { topAnchorContraint.constant = bottomPositionConstant + 8; return }
            guard newConstant >= topPositionConstant - 8 else { topAnchorContraint.constant = topPositionConstant - 8; return }
            
            topAnchorContraint.constant = newConstant
            
        case .ended:
            
            if v < -3000 {
                topAnchorContraint.constant = topPositionConstant
                
            }  else if v > 3000 {
                topAnchorContraint.constant = bottomPositionConstant
                
            } else if newConstant > ((middlePositionConstant + bottomPositionConstant) / 2) { // Bottom Third
                if v < -600 { topAnchorContraint.constant = middlePositionConstant }
                else { topAnchorContraint.constant = bottomPositionConstant }
                
            } else if newConstant < ((topPositionConstant + middlePositionConstant) / 2) { // Top Third
                if v > 600 { topAnchorContraint.constant = middlePositionConstant }
                else { topAnchorContraint.constant = topPositionConstant }
                
            } else {  // Middle Third
                if v > 600 { topAnchorContraint.constant = bottomPositionConstant }
                else if v < -600 { topAnchorContraint.constant = topPositionConstant }
                else { topAnchorContraint.constant = middlePositionConstant }
            }
            
            animateLayout()
 
        default: break
        }
    }
    
    func animateLayout(completionHandler: (() -> Void)? = nil) {
        guard let topAnchorContraint = topAnchorContraint else { return }
        
        var inset = self._target.collectionView.contentInset
        inset.bottom = -topAnchorContraint.constant
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            self._target.view.layoutIfNeeded()
            self._target.collectionView.contentInset = inset
            
            let bottomTableViewInset = self.bounds.height - (self.bottomPositionConstant - topAnchorContraint.constant) + self.tabbarHeight
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomTableViewInset, right: 0)
            self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomTableViewInset, right: 0)
            
        }) { bool in
            completionHandler?()
        }
    }
}

extension OverlayView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _target.recipe?.subRecipesArr.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _target.recipe?.subRecipesArr[section].ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = recipe!.subRecipesArr[indexPath.section].ingredients[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        cell._target = _target
        cell.setUpViews()
        cell.ingredient = ingredient
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else { return 0 }
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section != recipe!.subRecipesArr.count - 1 else { return 0 }
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != recipe!.subRecipesArr.count - 1 else { return nil }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        let header = SubRecipeIngredientsHeader()
        header.setUpViews()
        header.titleLabel.text = recipe!.subRecipesArr[section].name
        return header
    }

    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecipeDetailIngredientsCell.rowHeight
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 20 || topAnchorContraint?.constant != topPositionConstant)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 20 { scrollView.bounces = true }
    }
}

extension OverlayView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if tableView.contentOffset.y > 20 || topAnchorContraint?.constant != topPositionConstant {
            return false
        }
        return true
    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
}
