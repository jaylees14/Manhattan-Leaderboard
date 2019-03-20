//
//  LoginViewController.swift
//  Blueprint
//
//  Created by Jay Lees on 26/02/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        loginButton.isEnabled = false
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        loginButton.layer.cornerRadius = 5
    }

    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        // Only enable login if both text fields are non-empty
        self.loginButton.isEnabled = !username.isEmpty && !password.isEmpty
    }
    
    // MARK: - Actions
    @IBAction func passwordEnterTapped(_ sender: UIButton) {
        loginTapped(sender)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        // Disable login and show spinner
        loginButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // Log user in, informing delegate if successful
        BlueprintAPI.login(username: username, password: password) { (result) in
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "toLeaderboard", sender: nil)
            case .failure(let error):
                // Show error and revert UI to allow log in again
                let alert = UIAlertController(title: "Couldn't log in", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.isHidden = true
                self.loginButton.isHidden = false
            }
        }
    }
}
