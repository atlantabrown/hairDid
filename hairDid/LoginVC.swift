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
    
    var ref = Database.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
         //Do any additional setup after loading the view.
        
// we at first want to make sure the user isn't logged in
        if isUserLoggedIn() {
          // Show settings and highlight the logout feature
        } // otherwise they can continue to login page
        
        ref = Database.database().reference(withPath: "users")
        
        ref.observe(.value, with: { snapshot in
          print(snapshot.value as Any)
        })
        
    }
    // we don't want the user to be logged into multiple accounts at once because they could
    // override other user information
    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    
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
              print(" \n User signs in successfully \n")
              let alertController = UIAlertController(title: nil, message: "Signed in successfully", preferredStyle: .alert)
              alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alertController, animated: true)
              
              // direct user to their correct home page, will pull from database to determine their account type
              let user = Auth.auth().currentUser
              let uid = user!.uid
              print("\n my uid profile\(uid) \n ")
//              let accountType123 = self.ref.child("profile\(uid)/accountType")
//              //print("\n my account type \(accountType) \n ")
//              print("\n my account type \(accountType123) \n ")
//
              self.ref.child("profile\(uid)").getData(completion:  { error, snapshot in
                guard error == nil else {
                  print(error!.localizedDescription)
                  return
                }
                let accountType = snapshot.value as? String ?? "Unknown"
                  print("snapshot.value is: \(snapshot.value)")
                print("\n my account type \(accountType) \n ")
              })
              
          }
        }
        
//        func getUserAccountType(String: uid) -> String {
//            ref.child("users/\(uid)/accountType").getData(completion:  { error, snapshot in
//              guard error == nil else {
//                print(error!.localizedDescription)
//                return;
//              }
//              let userName = snapshot.value as? String ?? "Unknown";
//            });
//        }
        
        // Communicate with user about any errors that occured 
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
        
    }
}
