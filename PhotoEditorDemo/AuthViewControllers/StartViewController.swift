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
import Localize_Swift

class StartViewController: UIViewController {
    
    // Login and sign up are configured in Storyboard since they are just segues to another viewControllers
    
    // All of this code is just copy-paste from Firebase instructions
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
                    // Here the user is signed in, so we present the mainViewController
                        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                        if let mainController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                            self?.navigationController?.setViewControllers([mainController], animated: true)
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
}
