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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 146, left: 0, bottom: 0, right: 0)
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
    
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "newCell")
        cell.textLabel?.text = "Hello"
        return cell
    }
}
