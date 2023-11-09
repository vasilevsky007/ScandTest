//
//  AdminViewController.swift
//  ScandTest
//
//  Created by Alex on 5.11.23.
//

import UIKit
import FirebaseAuth

class AdminAuthController: UIViewController {
    private var auth = Auth.auth()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startLogIn(_ sender: UIButton) {
        loginButton.isEnabled = false
        loginButton.configuration?.showsActivityIndicator = true
        loginButton.tintColor = .label
        auth.signIn(
            withEmail: emailField.text!,
            password: passwordField.text!) { 
                [weak self] result, error in
                if let error = error {
                    self?.errorText.text = error.localizedDescription
                    self?.loginButton.configuration?.showsActivityIndicator = false
                    self?.loginButton.isEnabled = true
                } else if let result = result {
                    self?.loginButton.configuration?.showsActivityIndicator = false
                    self?.loginButton.isEnabled = true
                    self?.performSegue(
                        withIdentifier: "Logged In Segue",
                        sender: nil
                    )
                }
                self?.loginButton.configuration?.showsActivityIndicator = false
                self?.loginButton.isEnabled = true
        }
    }

}
