//
//  ZoomabbleImageView.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

class ZoomableImageView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            zoomImageView.image = image
        }
    }
    
    lazy var zoomImageView: UIImageView = {
        let iv = UIImageView(image: self.image)
        iv.layer.masksToBounds = false
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOffset = CGSize(width: 2, height: 2)
        iv.layer.shadowRadius = 8
        iv.layer.shadowOpacity = 0.3
        return iv
    }()
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
        
    override init(image: UIImage?) {
        super.init(image: image)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        isUserInteractionEnabled = true
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom(_:)))
        self.addGestureRecognizer(zoom)
    }
    
    var startingPos: CGPoint?
    var lastPos: CGPoint?
    var lastNumTouches = 0
    @objc func handleZoom(_ zoom: UIPinchGestureRecognizer) {
        guard let window = UIApplication.shared.keyWindow else { return }
        switch zoom.state {
        case .began:
            startingPos = zoom.location(in: window)
            window.addSubview(blackView)
            window.addSubview(zoomImageView)
            blackView.frame = window.frame
            zoomImageView.frame = self.convert(self.bounds, to: window)
            self.isHidden = true
            
        case .changed:
            let center = self.convert(self.center, to: window)
            let location = zoom.location(in: window)
            if let start = startingPos, let last = lastPos, zoom.numberOfTouches == 1, lastNumTouches == 2 { // corrects offset of when second touch is released
                startingPos = CGPoint(x: start.x + (location.x - last.x), y: start.y + (location.y - last.y))
            }
            let translation = CGPoint(x: location.x - (startingPos?.x ?? 0), y: location.y - (startingPos?.y ?? 0)) // translation between original center and current center
            let scale = zoom.scale >= 0.8 ? zoom.scale : 0.8
            blackView.alpha = (scale >= 2) ? 0.7 : (scale - 1) * 0.7
            zoomImageView.frame = CGRect(x: (center.x + translation.x) - (frame.width * scale / 2), y: (center.y + translation.y) - (frame.height * scale / 2), width: frame.width * scale, height: frame.height * scale)
            lastPos = location
            lastNumTouches = zoom.numberOfTouches
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                self.zoomImageView.frame = self.convert(self.bounds, to: window)
                self.blackView.alpha = 0
            }) { (bool) in
                window.willRemoveSubview(self.zoomImageView)
                window.willRemoveSubview(self.blackView)
                self.zoomImageView.removeFromSuperview()
                self.blackView.removeFromSuperview()
                self.isHidden = false
                self.lastNumTouches = 0
            }

        default:
            break
        }
    }
}
