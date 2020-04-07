//
//  BaseCells.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    var animate = false
    var initialSpringScale: CGFloat = 0.9
    var initialSpringVelocity: CGFloat = 5.0
    var springDampening: CGFloat = 0.5
    var springDuration: Double = 0.8
    override var isHighlighted: Bool {
        didSet {
            if animate {
                if isHighlighted {
                    UIView.animate(withDuration: 0.16, delay: 0, options: .curveLinear, animations: {
                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }) { (_) in
                    }
                } else {
                    UIView.animate(withDuration: 0.16, delay: 0, options: .curveLinear, animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) { (_) in
                    }
                }
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if animate {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: self.initialSpringScale, y: self.initialSpringScale)
                }) { (_) in
                    UIView.animate(withDuration: self.springDuration, delay: 0, usingSpringWithDamping: CGFloat(self.springDampening), initialSpringVelocity: self.initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    func setUpViews() {
        
    }
}

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



class AnimatedButton: UIButton {
    var animate = false
    var initialSpringScale: CGFloat = 0.8
    var initialSpringVelocity: CGFloat = 6.0
    var springDampening: CGFloat = 0.4
    var springDuration: Double = 0.6
    override var isHighlighted: Bool {
        didSet {
            if animate {
                if isHighlighted {
                    UIView.animate(withDuration: 0.16, delay: 0, options: .curveLinear, animations: {
                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }) { (_) in
                    }
                } else {
                    UIView.animate(withDuration: 0.16, delay: 0, options: .curveLinear, animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) { (_) in
                    }
                }
            }
        }
    }
    var selectedTintColor: UIColor?
    var unselectedTintColor: UIColor?
    override var isSelected: Bool {
        didSet {
            if let slctColor = self.selectedTintColor, let unslctColor = self.unselectedTintColor {
                self.tintColor = self.isSelected ? slctColor : unslctColor
            }
            if animate {
                transform = CGAffineTransform(scaleX: initialSpringScale, y: initialSpringScale)

                UIView.animate(withDuration: springDuration, delay: 0, usingSpringWithDamping: CGFloat(springDampening), initialSpringVelocity: initialSpringVelocity, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.transform = CGAffineTransform.identity
                    }, completion: nil)
            }
        }
    }
}
