//
//  OnBoardingViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/29/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccauntButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInButtonAction(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTexField.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func createAccauntButtonAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTexField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if result != nil {
                    self.performSegue(withIdentifier: "GoToApplication", sender: self)
                }
                else {
                    print("ERR: Can't create user")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTexField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OnBoardingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTexField.becomeFirstResponder()
        }
        if textField == passwordTexField {
            textField.resignFirstResponder()
        }
        return true
    }
}
