//
//  ViewController.swift
//  DTT
//
//  Created by Martin Herholdt Rasmussen on 14/03/2018.
//  Copyright © 2018 Martin Herholdt Rasmussen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.delegate = self
        loginButton.readPermissions =  ["user_friends"]

        if let accessToken = FBSDKAccessToken.current(), let token = accessToken.tokenString {
            loginFirebase(token: token)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        loginFirebase(token: FBSDKAccessToken.current().tokenString)
    }

    @IBAction func showFriendList() {
        guard let _ = FBSDKAccessToken.current() else {
            UIAlertView(title: "Error", message: "You're not logged in. You have to log in with Facebook before you can continue", delegate: nil, cancelButtonTitle: "Alright").show()
            return
        }
        self.performSegue(withIdentifier: "ShowFriendList", sender: nil)
    }
    
    func loginFirebase(token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Alright").show()
                return
            }
            UIAlertView(title: "Success", message: "You've succesfully logged in", delegate: nil, cancelButtonTitle: "Alright").show()
            self.showFriendList()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth =
            Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        UIAlertView(title: "Success", message: "You've succesfully logged out", delegate: nil, cancelButtonTitle: "Alright").show()
    }
    
    @IBAction func showCountriesList(_ sender: Any) {
        performSegue(withIdentifier: "ShowCountryList", sender: nil)
    }
    
}

