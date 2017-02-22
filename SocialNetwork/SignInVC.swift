//
//  SignInVC.swift
//  SocialNetwork
//
//  Created by Sean Perez on 2/21/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: Constants.Keys.keyUID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook \(error)")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase \(error)")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(user.uid)
                }
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email authenticated with Firebase")
                    self.completeSignIn(user!.uid)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Email unable to authenticate with Firebase")
                        } else {
                            print("New user email successfully authenticated with Firebase")
                            self.completeSignIn(user!.uid)
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(_ id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: Constants.Keys.keyUID)
        print("Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}

