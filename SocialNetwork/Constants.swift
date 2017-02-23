//
//  Constants.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    struct Keys {
        static let grayShadow: CGFloat = 120/255
        static let keyUID = "uid"
        static let uniqueServiceName = "com.SeanPerez.SocialNetwork"
    }
    
    struct Cache {
        static var imageCache: NSCache<NSString, UIImage> = NSCache()
    }
}
