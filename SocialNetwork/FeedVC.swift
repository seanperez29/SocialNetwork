//
//  FeedVC.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionField: CustomTextField!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 81, left: 0, bottom: 0, right: 0)
        DataService.dataService.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String:AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: Constants.Keys.keyUID)
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print("Unable to sign out \(error)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("Must enter a caption")
            return
        }
        guard let image = postImage.image, imageSelected == true else {
            print("Must pick an image")
            return
        }
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.dataService.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase storage")
                } else {
                    print("Successfully uploaded image to Firebase storage")
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imageUrl: downloadURL)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post: [String:Any] = ["caption": captionField.text!, "imageUrl": imageUrl, "likes": 0]
        let firebasePost = DataService.dataService.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        postImage.image = UIImage(named: "add-image")
        imageSelected = false
        tableView.reloadData()
    }
    
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        if let image = Constants.Cache.imageCache.object(forKey: post.imageUrl as NSString) {
            cell.configureCell(post: post, image: image)
        } else {
            cell.configureCell(post: post)
        }
        return cell
    }
}

extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postImage.image = image
        }
        imageSelected = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
