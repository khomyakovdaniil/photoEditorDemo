//
//  RestorePasswordViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth
import Localize_Swift

class RestorePasswordViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func restorePassword(_ sender: Any) {
        guard let email = email.text else { return }
        // We send a password recovery letter to provided e-mail
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if error != nil {
                // If the letter wasn't sent we show the user an error text
                print("error reseting password")
                let alertController = UIAlertController(title: Constants.Alerts.error.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            } else {
                // If the letter was sent successfully we tell the user about it
                let alertController = UIAlertController(title: Constants.Alerts.passwordRecoverySent.localized(), message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: Constants.Alerts.ok.localized(), style: .cancel, handler: { _ in self?.dismiss(animated: true) })
                
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
                print("Sent recovery email")
            }
            
        }
    }
    
}
