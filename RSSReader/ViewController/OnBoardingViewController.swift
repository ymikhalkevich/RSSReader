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

        if let email = emailTextField.text, let password = passwordTexField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if let u = result {
                    self.performSegue(withIdentifier: "GoToApplication", sender: self)
                }
                else {
                    print("ERR: ")
                }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
