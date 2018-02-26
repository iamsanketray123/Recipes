//
//  UIViewX.swift
//  Recipes
//
//  Created by Sanket  Ray on 26/02/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewX: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 3
    @IBInspectable var shadowColor : UIColor? = UIColor.black
    @IBInspectable var shadowOffSetWidth : Int = 2
    @IBInspectable var shadowOffSetHeight : Int = 2
    @IBInspectable var shadowOpacity : Float = 0.2
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
    
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

