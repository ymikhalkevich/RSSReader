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

        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonAction(_ sender: UIButton) {

//        if let email = emailTextField.text, let password = passwordTexField.text {
//            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//
//                if let u = result {
//                    self.performSegue(withIdentifier: "GoToApplication", sender: self)
//                }
//                else {
//                    print("ERR: ")
//                }
//            }
//        }
        
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
                
                if let u = result {
                    self.performSegue(withIdentifier: "GoToApplication", sender: self)
                }
                else {
                    print("ERR: ")
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
        // Dispose of any resources that can be recreated.
    }
/*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "GoToApplication", sender: self)
        }
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
