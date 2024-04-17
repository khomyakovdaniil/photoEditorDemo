//
//  StartViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class StartViewController: UIViewController {
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] result, error in
                if error == nil{
                        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                        if let mainController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                            self?.navigationController?.setViewControllers([mainController], animated: true)
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
