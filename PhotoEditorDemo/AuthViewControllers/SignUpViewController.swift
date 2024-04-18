//
//  SignUpViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth
import Localize_Swift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
        // The passwords should match each other, otherwise we show an error alert
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: Constants.Alerts.wrongPasswordTitle, message: Constants.Alerts.wrongPasswordMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: Constants.Alerts.ok, style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            // If the input is correct we try to create a user with provided credentials
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ [weak self] (user, error) in
                if error == nil {
                    guard let user = Auth.auth().currentUser else {
                        return
                    }
                    // If the user creation is successfull we send the verification e-mail, and show an alert telling the user to check it
                    user.sendEmailVerification { error in
                        let alertController = UIAlertController(title: Constants.Alerts.verificationSentOnSignUp.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    // If user creation failed we show the error text provided by firebase
                    let alertController = UIAlertController(title: Constants.Alerts.error.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
