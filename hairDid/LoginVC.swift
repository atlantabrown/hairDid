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
    
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
         //Do any additional setup after loading the view.
        
        // one user at a time should be logged in to avoid overriding other's info
        if isUserLoggedIn() {
          // Show settings and shake the logout feature
        }
        
        // add back removed VC from tab bar controller in settings when user logs out
    }
    
    // checks if user is logged in
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
                alertMessage = "Email and password accounts are not enabled, oh no!"
                
            case .userDisabled:
                alertMessage = "This user's account has been disabled by admin..."
                
            case .wrongPassword:
                alertMessage = "Password is invalid. Please try again :)"
                
            case .invalidEmail:
                alertMessage = "Email address is incorrect. Please try again :)"
                
            default:
                break
            }
              //Communicate with user about any errors that occured
              let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
              alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alertController, animated: true)
          } else {
              // popup that tells the user success!!
              let alertController = UIAlertController(title: nil, message: "Signed in successfully", preferredStyle: .alert)
              
              alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                  // direct user to their correct home page based off data type
                  let user = Auth.auth().currentUser
                  let uid = user!.uid
                  let ref = Database.database().reference()
                  ref.child("users/\(uid)/accountType").getData(completion:  { error, snapshot in
                    guard error == nil else {
                      print(error!.localizedDescription)
                      return
                    }
                    
                    // 
                    let accountType = snapshot.value as? String ?? "Unknown"
                      if (accountType == "provider"){
                          self.performSegue(withIdentifier: "goToProviderHome", sender: self.loginButton)
                          print("provider home HERE")
                          //self.tabBarController?.viewControllers?.removeFirst()
                      }else {
                          self.performSegue(withIdentifier: "goToClientHome", sender: self.loginButton)
                          print("client home")
                      }
                  })
                  
              }))
              self.present(alertController, animated: true)
          }
        }
    }
//
//    // variable wont save outside closure yikes
//    func getUserAccountType(uid: String) -> String {
//        var accountType = ""
//        let ref = Database.database().reference()
//        ref.child("users/\(uid)/accountType").getData(completion:  { error, snapshot in
//          guard error == nil else {
//            print(error!.localizedDescription)
//            return
//          }
//
//          accountType = snapshot.value as? String ?? "Unknown"
//            print("\n my account type inside closure \(accountType) \n")
//
//        })
//        print("\n my account type \(accountType) \n")
//        return accountType
//    }
}
