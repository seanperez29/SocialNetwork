//
//  PostCell.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.caption.text = post.caption
        self.likesLabel.text = String(post.likes)
        
        if image != nil {
            self.postImage.image = image
        } else {
            let reference = FIRStorage.storage().reference(forURL: post.imageUrl)
            reference.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Error obtaining image from Firebase")
                } else {
                    print("Image downloaded from Firebase")
                    let image = UIImage(data: data!)
                    self.postImage.image = image
                    Constants.Cache.imageCache.setObject(image!, forKey: post.imageUrl as NSString)
                }
            })
        }
    }

}
