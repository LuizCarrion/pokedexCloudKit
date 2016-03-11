//
//  Utils.swift
//  bid
//
//  Created by Phelippe Amorim on 11/13/15.
//  Copyright © 2015 Phelippe Amorim. All rights reserved.
//

import UIKit

class Util {
    class func addChildView(child: UIView, toFather father: UIView, whithAutoLayout autoLayout: Bool = false) {
        father.addSubview(child)
        
        if autoLayout {
            child.translatesAutoresizingMaskIntoConstraints = false
            
            let viewsDictionary = ["father":father, "child":child]
            
            let view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[child(==father)]-0-|", options: .AlignAllLeading, metrics: nil, views: viewsDictionary)
            let view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[child(==father)]-0-|", options: .AlignAllLeading, metrics: nil, views: viewsDictionary)
            
            NSLayoutConstraint.activateConstraints(view_constraint_V)
            NSLayoutConstraint.activateConstraints(view_constraint_H)
        }
    }
}