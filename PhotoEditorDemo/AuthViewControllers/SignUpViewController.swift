//
//  SignUpViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ [weak self] (user, error) in
                if error == nil {
                    guard let user = Auth.auth().currentUser else {
                        return
                    }
                    if user.isEmailVerified {
                        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                        if let mainController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                            self?.navigationController?.setViewControllers([mainController], animated: true)
                        }
                    } else {
                        user.sendEmailVerification { error in
                            let alertController = UIAlertController(title: "Verification link sent. Please verify your e-mail to be able to sign in", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            alertController.addAction(defaultAction)
                            self?.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
