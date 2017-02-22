//
//  CustomImageView.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
@IBDesignable

class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = frame.width / 2
            layer.masksToBounds = cornerRadius >= 0
        }
    }

}
