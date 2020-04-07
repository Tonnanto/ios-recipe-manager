//
//  TabBarController.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController  {
    
    static var main: TabBarController?
    
    var wishlistTabView: UIView?
    
    var firstItemImageView: UIImageView?
    var secondItemImageView: UIImageView?
    var thirdItemImageView: UIImageView?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        TabBarController.main = self
        self.tabBar.tintColor = UIColor(named: "heavyTint")
    
        tabBar.items?[0].image = UIImage(named: "recipes_75")
        tabBar.items?[0].selectedImage = UIImage(named: "recipe_80")
        tabBar.items?[1].image = UIImage(systemName: "bookmark")
        tabBar.items?[1].selectedImage = UIImage(systemName: "bookmark.fill")
        tabBar.items?[2].image = UIImage(systemName: "more")
        tabBar.items?[2].selectedImage = UIImage(systemName: "more")

        tabBar.items?[0].tag = 0
        tabBar.items?[1].tag = 1
        tabBar.items?[2].tag = 2

        guard tabBar.subviews.count == 3 else { return }
        wishlistTabView = tabBar.subviews[2]
        
        tabBar.subviews[1].subviews.forEach({ (view) in
            if let imageView = view as? UIImageView { firstItemImageView = imageView }
        })
        tabBar.subviews[2].subviews.forEach({ (view) in
            if let imageView = view as? UIImageView { secondItemImageView = imageView }
        })
        tabBar.subviews[0].subviews.forEach({ (view) in
            if let imageView = view as? UIImageView { thirdItemImageView = imageView }
        })

        
        
    }
    
    func pulse(item: Int) {
        var imageView: UIImageView?
        switch item {
        case 0: imageView = firstItemImageView
        case 1: imageView = secondItemImageView
        case 2: imageView = thirdItemImageView
        default: break
        }
        
        if let imageView = imageView {
            
            imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

            UIView.animate(withDuration: 1.4,
                                       delay: 0,
                                       usingSpringWithDamping: CGFloat(0.3),
                                       initialSpringVelocity: CGFloat(4.0),
                                       options: UIView.AnimationOptions.allowUserInteraction,
                                       animations: {
                                            imageView.transform = CGAffineTransform.identity
                                        },
                                       completion: { Void in()  }
            )
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        pulse(item: item.tag)
    }
    
    func animateThumbnailWishlist(image: UIImage?) {
        if let view = wishlistTabView {
            let iv = UIImageView(image: image)
            iv.layer.zPosition = -1
            iv.layer.shadowOffset = CGSize(width: 0, height: 0)
            iv.layer.shadowRadius = 16
            iv.layer.shadowOpacity = 0.2
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            let initWidth = view.bounds.height + 4
            let endWidth = view.bounds.height - 8
            iv.frame = CGRect(x: (view.bounds.width - initWidth) / 2, y: -66, width: initWidth, height: initWidth)
            view.addSubview(iv)
            
            UIView.animate(withDuration: 0.5, delay: 0.7, options: .allowUserInteraction, animations: {
                iv.frame = CGRect(x: (view.bounds.width - endWidth) / 2, y: 8, width: endWidth, height: endWidth)
                iv.alpha = 0
            }) { (_) in
                view.willRemoveSubview(iv)
                iv.removeFromSuperview()
                self.pulse(item: 1)
            }
        }
    }
}
