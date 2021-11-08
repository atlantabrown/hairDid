//
//  CreateAccountVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/2/21.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var providerClientSeg: UISegmentedControl!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userPasswordTF: UITextField!
    
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segSelected(_ sender: Any) {
        switch providerClientSeg.selectedSegmentIndex {
        case 0:
            userType = "provider"
        case 1:
            userType = "client"
        default:
            print("This shouldn't happen")
        }
        createAccountButton.setTitle("create \(userType) account", for: .normal)
    }
    
    // ask for suggestions for how I can split this up into a function, method too big
    @IBAction func createAccountSelected(_ sender: Any) {
        
        // makes sure that there is a non empty email and password field
        guard let email = userEmailTF.text else { return }
        guard let password = userPasswordTF.text else { return }
        
        var alertMessage: String = ""
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                  // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    alertMessage = "Email and password accounts are not enabled"
                case .userDisabled:
                  // Error: The user account has been disabled by an administrator.
                    alertMessage = "User account has been disabled by an admin."
                case .wrongPassword:
                  // Error: The password is invalid or the user does not have a password.
                    if (password.count == 0){
                        alertMessage = "Please type in a password."
                    } else if (password.count <= 6){
                        alertMessage = "Password must be greater than 6 characters. Please try again."
                    }
                case .invalidEmail:
                  // Error: Indicates the email address is malformed.
                    alertMessage = "Please type in a valid email address"
                default:
                    //print("Error: \(error.localizedDescription)")
                    alertMessage = "Email already in use. Please try again."
                }
            } else {
                //alertMessage = "Account created successfully!"
                
                // add some sort of message about account being created successfully
                
                // user signs in successfully
                Auth.auth().signIn(withEmail: self.userEmailTF.text!,
                                   password: self.userPasswordTF.text!)
                
                // if correctly signed in, direct them to the appropriate VC
                // will need to find a way to send over their name
                // can segue and delgate stuff go here??
                if (self.userType == "provider"){
                    self.performSegue(withIdentifier: "goToEditProviderProfile", sender: self.createAccountButton)
                }else {
                    self.performSegue(withIdentifier: "goToEditClientProfile", sender: self.createAccountButton)
                }
            }
                
          // Communicate with user about errors
          let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alertController, animated: true)
        }
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
