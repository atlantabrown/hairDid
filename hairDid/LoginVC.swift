//
//  ViewController.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/2/21.
//
//
import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var loginEmailTF: UITextField!
    @IBOutlet weak var loginPasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
         //Do any additional setup after loading the view.
        
// we at first want to make sure the user isn't logged in
//        if isUserLoggedIn() {
//          // Show settings and highlight the logout feature
//        } else {
//          // Show login page
//        }
    }
    // we don't want the user to be logged into multiple accounts at once because they could
    // override other user information
//    func isUserLoggedIn() -> Bool {
//      return Auth.auth().currentUser != nil
//    }
    
    
    // logs the user in if the account exists
    @IBAction func loginButtonPressed(_ sender: Any) {
        // makes sure that there is a non empty email and password field
                guard let email = loginEmailTF.text else { return }
                guard let password = loginPasswordTF.text else { return }
        
        var alertMessage: String = ""
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
          if let error = error as? NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
              // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                alertMessage = "Email and password accounts are not enabled, oh no!"
            case .userDisabled:
              // Error: The user account has been disabled by an administrator.
                alertMessage = "This user's account has been disabled by admin..."
            case .wrongPassword:
              // Error: The password is invalid or the user does not have a password.
                alertMessage = "Password is invalid. Please try again :)"
            case .invalidEmail:
              // Error: Indicates the email address is malformed.
                alertMessage = "Email address is incorrect. Please try again :)"
            default:
                break
            }
          } else {
              print("User signs in successfully")
              // do I need the below info idk
              let userInfo = Auth.auth().currentUser
              let email = userInfo?.email
              
              // direct user to their correct home page
              // will pull from database to determine their account type 
              let user = Auth.auth().currentUser
          }
        }
        
        
        // Communicate with user about any errors that occured 
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
        
    }
}
