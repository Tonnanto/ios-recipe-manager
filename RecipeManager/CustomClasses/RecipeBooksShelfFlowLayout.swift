//
//  RecipeBooksShelfFlowLayout.swift
//  RecipeManager
//
//  Created by Anton Stamme on 10.04.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class RecipeBooksShelfFlowLayout: UICollectionViewFlowLayout {
    
    open var maxAngle : CGFloat = CGFloat.pi / 2
    open var isFlat : Bool = false

    fileprivate var _halfDim : CGFloat {
        get {
            return _visibleRect.width / 2
        }
    }
    fileprivate var _mid : CGFloat {
        get {
            return _visibleRect.midX
        }
    }
    fileprivate var _visibleRect : CGRect {
        get {
            if let cv = collectionView {
                return CGRect(origin: cv.contentOffset, size: cv.bounds.size)
            }
            return CGRect.zero
        }
    }
    func initialize() {
        minimumLineSpacing = 0.0
        scrollDirection = .horizontal
    }

    override init() {
        super.init()
        self.initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            let distance = (attributes.frame.midX - _mid)
            var transform = CATransform3DIdentity
            
            if distance < 500 {
                let scale = (1 - abs(distance / 700))
                transform = CATransform3DScale(transform, scale, scale, 1)
//                transform = CATransform3DTranslate(transform, -(distance * 0.75), 0, -abs(distance))
//                attributes.alpha = (1 - abs(distance / 1500))
            }

//
//            transform = CATransform3DTranslate(transform, -distance, 0, -_halfDim)
//            transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0)
//
//            transform = CATransform3DTranslate(transform, 0, 0, _halfDim)
            attributes.transform3D = transform
//            attributes.alpha = abs(currentAngle) < maxAngle ? 1.0 : 0.0
            return attributes

        }

        return nil
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.collectionView!.numberOfSections > 0 {
            for i in 0 ..< self.collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: i, section: 0)
                attributes.append(self.layoutAttributesForItem(at: indexPath)!)
            }
        }
        return attributes
    }
    var snapToCenter : Bool = true
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let collectionViewBounds = self.collectionView?.bounds {
            let halfWidthOfVC = collectionViewBounds.size.width * 0.5
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidthOfVC
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: collectionViewBounds) {
                var candidateAttribute : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    let candAttr : UICollectionViewLayoutAttributes? = candidateAttribute
                    if candAttr != nil {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttr!.center.x - proposedContentOffsetCenterX
                        if abs(a) < abs(b) {
                            candidateAttribute = attributes
                        }
                    } else {
                        candidateAttribute = attributes
                        continue
                    }
                }
                
                if candidateAttribute != nil {
                    return CGPoint(x: candidateAttribute!.center.x - halfWidthOfVC, y: proposedContentOffset.y);
                }
            }
        }
        return CGPoint.zero
    }
}
