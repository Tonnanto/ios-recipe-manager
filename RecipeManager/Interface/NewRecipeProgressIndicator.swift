//
//  NewRecipeProgressIndicator.swift
//  RecipeManager
//
//  Created by Anton Stamme on 21.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class NewRecipeProgressIndicator: UIView {
    
    var _target: NewRecipeViewController!
    
    var color = UIColor(named: "tint")
    
    lazy var line: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        view.progress = 0
        view.progressTintColor = UIColor(named: "tint")
        return view
    }()
    
    func indicaotrView(_ number: Int) -> IndicaorView {
        let view = IndicaorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.label.text = "\(number)"
        view.setUpViews()
        return view
    }
    
    lazy var indicatorView1 = indicaotrView(1)
    lazy var indicatorView2 = indicaotrView(2)
    lazy var indicatorView3 = indicaotrView(3)

    lazy var indicatorViews = [indicatorView1, indicatorView2, indicatorView3]
    
    var selectedHeightConstant: CGFloat = 0
    var unselectedHeightConstant: CGFloat = 0
    
    
    func setUpViews(height: CGFloat) {
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectFirst))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(selectSecond))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectThird))
        indicatorView1.addGestureRecognizer(tap1)
        indicatorView2.addGestureRecognizer(tap2)
        indicatorView3.addGestureRecognizer(tap3)

        selectedHeightConstant = height
        unselectedHeightConstant = height * 0.5

        addSubview(line)
        addSubview(indicatorView1)
        addSubview(indicatorView2)
        addSubview(indicatorView3)
        
        for iv in indicatorViews {
            addConstraints([
                NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: iv, attribute: .width, relatedBy: .equal, toItem: iv, attribute: .height, multiplier: 1, constant: 0)
            ])
        }
        
        indicatorView1.heightAnchorConstraint = indicatorView1.heightAnchor.constraint(equalToConstant: selectedHeightConstant)
        indicatorView2.heightAnchorConstraint = indicatorView2.heightAnchor.constraint(equalToConstant: unselectedHeightConstant)
        indicatorView3.heightAnchorConstraint = indicatorView3.heightAnchor.constraint(equalToConstant: unselectedHeightConstant)
        indicatorView1.heightAnchorConstraint?.isActive = true
        indicatorView2.heightAnchorConstraint?.isActive = true
        indicatorView3.heightAnchorConstraint?.isActive = true
        
        
        addConstraints([
            NSLayoutConstraint(item: line, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: indicatorView1, attribute: .right, multiplier: 1, constant: -3),
            NSLayoutConstraint(item: line, attribute: .right, relatedBy: .equal, toItem: indicatorView3, attribute: .left, multiplier: 1, constant: 3),


            NSLayoutConstraint(item: indicatorView1, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: indicatorView2, attribute: .centerX, relatedBy: .equal, toItem: line, attribute: .centerX, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: indicatorView3, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        contentOffsetChanged(0)

    }
    
    @objc func selectFirst() {
        _target.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    @objc func selectSecond() {
        _target.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    @objc func selectThird() {
        _target.collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func contentOffsetChanged(_ offset: CGFloat) {
        let firstPagePos: CGFloat = 0
        let secondPagePos: CGFloat = _target.collectionView.bounds.width
        let thirdPagePos: CGFloat = _target.collectionView.bounds.width * 2
       
        let firstDist = abs(offset - firstPagePos)
        let secondDist = abs(offset - secondPagePos)
        let thirdDist = abs(offset - thirdPagePos)

        let firstHeight = selectedHeightConstant + (unselectedHeightConstant - selectedHeightConstant) * firstDist / _target.collectionView.bounds.width
        let secondHeight = selectedHeightConstant + (unselectedHeightConstant - selectedHeightConstant) * secondDist / _target.collectionView.bounds.width
        let thirdHeight = selectedHeightConstant + (unselectedHeightConstant - selectedHeightConstant) * thirdDist / _target.collectionView.bounds.width

        indicatorView1.heightConstatnt = firstHeight > unselectedHeightConstant ? firstHeight : unselectedHeightConstant
        indicatorView2.heightConstatnt = secondHeight > unselectedHeightConstant ? secondHeight : unselectedHeightConstant
        indicatorView3.heightConstatnt = thirdHeight > unselectedHeightConstant ? thirdHeight : unselectedHeightConstant
        
        if offset < (firstPagePos + secondPagePos) / 2 {
            line.progress = Float(offset / secondPagePos)
            indicatorView1.isSelected = true
            indicatorView2.isSelected = false
            indicatorView3.isSelected = false
        } else if offset < (secondPagePos + thirdPagePos) / 2 {
            if offset > secondPagePos {
                line.progress = 0.5 + Float((offset - secondPagePos) / secondPagePos)
            }
            indicatorView1.isSelected = true
            indicatorView2.isSelected = true
            indicatorView3.isSelected = false
        } else {
            line.progress = 1
            indicatorView1.isSelected = true
            indicatorView2.isSelected = true
            indicatorView3.isSelected = true
        }

        for view in self.indicatorViews {
            view.layer.cornerRadius = view.heightConstatnt / 2
            view.label.font = UIFont.systemFont(ofSize: view.heightConstatnt * 0.7, weight: .medium) 
        }
    }
}


class IndicaorView: UIView {
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? UIColor(named: "tint") : .gray
        }
    }
    
    var heightAnchorConstraint: NSLayoutConstraint?
    var heightConstatnt: CGFloat = 0 {
        didSet {
            heightAnchorConstraint?.constant = heightConstatnt
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemBackground
//        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    func setUpViews() {
        addSubview(label)
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
    }
    
    
}
