//
//  CreateAccountVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/2/21.
//

import UIKit
import Firebase
import FirebaseStorage

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var providerClientSeg: UISegmentedControl!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userPasswordTF: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    // client is default value
    var userType = "client"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
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
    
    
    @IBAction func createAccountSelected(_ sender: Any) {
        // makes sure that there is a non empty email and password field
        guard let email = userEmailTF.text else { return }
        guard let password = userPasswordTF.text else { return }

        var alertMessage: String = ""
        Auth.auth().createUser(withEmail: email, password: password) { [self] user, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    alertMessage = "Email and password accounts are not enabled"
                    
                case .userDisabled:
                    alertMessage = "User account has been disabled by an admin."
                    
                case .wrongPassword:
                    alertMessage = "User password invalid."
                    
                case .invalidEmail:
                    alertMessage = "Please type in a valid email address"
                    
                default:
                    alertMessage = "Email already in use. Please try again."
                    if (password.count == 0){
                        alertMessage = "Please type in a password."
                    } else if (password.count <= 6){
                        alertMessage = "Password must be greater than 6 characters. Please try again."
                    }
                }
                // Communicate with user about any errors that occured
                let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
                
            } else {
                // save profile information to firebase database (used for login stuff)
                self.saveProfile(userName:self.userNameTF.text!, email:self.userEmailTF.text!, accountType: self.userType) { success in
                }
                
                // signs the user in
                Auth.auth().signIn(withEmail: self.userEmailTF.text!, password: self.userPasswordTF.text!)
                
                // popup that tells the user success!!
                let alertController = UIAlertController(title: nil, message: "Account created successfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    // if correctly signed in, direct them to the appropriate VC
                    // send their name over to profile
                    if (self.userType == "provider"){
                        self.performSegue(withIdentifier: "goToEditProviderProfile", sender: self.createAccountButton)
                    }else {
                        self.performSegue(withIdentifier: "goToEditClientProfile", sender: self.createAccountButton)
                    }
                }))
                self.present(alertController, animated: true)
            }
        }
    }
    
    // updates database with user profile name and type of account
    func saveProfile(userName: String, email: String, accountType: String, completion: @escaping ((_ success:Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        var userObject: [String: Any] = [:]
        if (accountType == "client"){
            userObject = [
                "name": userName as NSString,
                "accountType": accountType,
                "email": email as NSString,
                "style":"" as NSString,
                "avail":"" as NSString,
                "number":"" as NSString,
                "zipCode":"" as NSString,
                "covidPreference":"" as NSString,
            ]
        }else if (accountType == "provider"){
            userObject = [
                "userName": userName as NSString,
                "accountType": accountType,
                "email": email as NSString,
                "name": "" as NSString,
                "businessName": "" as NSString,
                "website":"" as NSString,
                "avail":"" as NSString,
                "style":"" as NSString,
                "number":"" as NSString,
                "zipCode":"" as NSString,
                "covidPreference":"" as NSString,
                "gallery":"" as NSString,
            ]
        }
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
}
