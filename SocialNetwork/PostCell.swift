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
    @IBOutlet weak var likeImage: UIImageView!
    let likesRef = DataService.dataService.REF_USER_CURRENT.child("likes")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTouchesRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
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
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
            } else {
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
            } else {
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
            }
        })
    }

}
