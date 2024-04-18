//
//  LoginViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth
import Localize_Swift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        // We try to sing in the user with provided credentials
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] (user, error) in
            if error == nil{
                guard let user = Auth.auth().currentUser else {
                    return
                }
                // The user is signed in, so we check if he has his e-mail verified
                if user.isEmailVerified {
                    // Verified user can proceed to enjoy the app
                    let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    if let mainController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                        self?.navigationController?.setViewControllers([mainController], animated: true)
                    }
                } else {
                    // Unverified user get's a verification e-mail and an alert telling him to check it
                    user.sendEmailVerification { error in
                        let alertController = UIAlertController(title: Constants.Alerts.verificationEmailSent.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                // Here the user couldn't sign in so we show him the error text provided by firebase
                let alertController = UIAlertController(title: Constants.Alerts.error.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
}
