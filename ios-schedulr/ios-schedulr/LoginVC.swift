//
//  ViewController.swift
//  ios-schedulr
//
//  Created by Chris Janowski on 3/30/18.
//  Copyright © 2018 schedulr. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

var isSigningIn = true

class LoginVC: UIViewController {

    // The handler for the auth state listener, to allow cancelling later
    
    var handle: AuthStateDidChangeListenerHandle?


    // Outlets for text fields, seg. control, button
    
    @IBOutlet weak var signinRegisterLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var loginRegisterSeg: UISegmentedControl!
    @IBOutlet weak var signinRegisterButton: UIButton!
    
    // Makes changes when user selects either Log In or Register
    @IBAction func switchLoginRegister(_ sender: Any) {
        isSigningIn = !isSigningIn
        
        if isSigningIn {
            signinRegisterLabel.text = "Sign In"
            signinRegisterButton.setTitle("Sign In", for: .normal)
            //confirmLabel.isHidden = true
            confirmPasswordTF.isHidden = true
        } else {
            signinRegisterLabel.text = "Register"
            signinRegisterButton.setTitle("Register", for: .normal)
            //confirmLabel.isHidden = false
            confirmPasswordTF.isHidden = false
        }
    }
    
    
    @IBAction func signinOrRegister(_ sender: Any) {
        
        guard let email = emailTF.text, let pass = passwordTF.text else {
            //self.createSimpleAlert(title: "Error", message: "Username or password incorrect.")
            print("Invalid input")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
            
            //
            // Check user is not null
            //
            
            guard (user?.uid) != nil else {
                
                //self.createSimpleAlert(title: "Error", message: "Username or password incorrect.")
                print("Invalid credentials")
                return
            }
            
            UserDefaults.standard.synchronize()
            
            self.passwordTF.text = ""
            
            self.performSegue(withIdentifier: "loginseg", sender: self)
            
        })
        
        
    }
    
    func initView() {
        confirmPasswordTF.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare for initial view
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

