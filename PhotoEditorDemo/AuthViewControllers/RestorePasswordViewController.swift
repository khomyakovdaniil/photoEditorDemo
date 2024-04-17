//
//  RestorePasswordViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth

class RestorePasswordViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func restorePassword(_ sender: Any) {
        guard let email = email.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if error != nil {
                print("error reseting password")
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Password recovery email sent", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in self?.dismiss(animated: true) })
                
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
                print("Sent recovery email")
            }
            
        }
    }
    
}
