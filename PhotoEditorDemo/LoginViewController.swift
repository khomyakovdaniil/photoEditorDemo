//
//  LoginViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 16.04.2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] (user, error) in
            if error == nil{
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
                        // TODO: verify e-mail screen
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
