//
//  CustomTextField.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
@IBDesignable

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: Constants.Keys.grayShadow, green: Constants.Keys.grayShadow, blue: Constants.Keys.grayShadow, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}
