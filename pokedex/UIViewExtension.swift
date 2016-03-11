//
//  UIViewExtension.swift
//  bid
//
//  Created by Phelippe Amorim on 11/11/15.
//  Copyright © 2015 Phelippe Amorim. All rights reserved.
//

import UIKit

extension UIView {
    
    func lock(duration: NSTimeInterval = 0.2) {
        
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0

            var imagesListArray = [UIImage]()
            for i in 1...4 {
                let imageName = "ditto\(i)"
                let image = UIImage(named: imageName)
                imagesListArray.append(image!)
            }
            
            let activity = UIImageView()
            
            activity.animationImages = imagesListArray
            activity.animationDuration = 1.0
           
            
            activity.center = lockView.center
            
            activity.translatesAutoresizingMaskIntoConstraints = false
            
            lockView.addSubview(activity)
            activity.startAnimating()
            
            Util.addChildView(lockView, toFather: self, whithAutoLayout: true)
            
            
            let xCenterConstraint = NSLayoutConstraint(item: activity, attribute: .CenterX, relatedBy: .Equal, toItem: lockView, attribute: .CenterX, multiplier: 1, constant: 0)
            
            let yCenterConstraint = NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: lockView, attribute: .CenterY, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activateConstraints([xCenterConstraint, yCenterConstraint])
            
            UIView.animateWithDuration(duration) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock(duration: NSTimeInterval = 0.2) {
        if let lockView = self.viewWithTag(10) {
            
            UIView.animateWithDuration(duration, animations: {
                lockView.alpha = 0.0
                }) { finished in
                    lockView.removeFromSuperview()
            }
        }
    }
}