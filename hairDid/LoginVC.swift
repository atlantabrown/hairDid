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
    
    private let loginContentView:UIView = {
      let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    private let unameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Email"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let pwordTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Password"
        txtField.borderStyle = .roundedRect
        txtField.isSecureTextEntry = true
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    let btnLogin:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Login", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
         //Do any additional setup after loading the view.
        
        loginContentView.addSubview(unameTxtField)
        loginContentView.addSubview(pwordTxtField)
        btnLogin.addTarget(self,
                                action: #selector(btnAction),
                                for: .touchUpInside)
        loginContentView.addSubview(btnLogin)
        
        view.addSubview(loginContentView)
        setUpAutoLayout()
        
        //self.view.addSubview(label)
        // one user at a time should be logged in to avoid overriding other's info
        if isUserLoggedIn() {
          // Show settings and shake/highlight the logout feature(??)
            
            let alert = UIAlertController(title: "A user is logged in!", message: "Would you like to log out?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                try! Auth.auth().signOut()
                let alertController = UIAlertController(title: nil, message: "Signed out successfully", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
                self.present(alertController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                let settingsVC = SettingsVC()
                settingsVC.modalPresentationStyle = .fullScreen
                self.present(settingsVC, animated: true)
            }))

            self.present(alert, animated: true)
            

        }

    }
    
    func setUpAutoLayout(){
        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor).isActive = true
        unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:40).isActive = true
        unameTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        unameTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        unameTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        pwordTxtField.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        pwordTxtField.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        pwordTxtField.heightAnchor.constraint(equalToConstant:50).isActive = true
        pwordTxtField.topAnchor.constraint(equalTo:unameTxtField.bottomAnchor, constant:20).isActive = true
        
        btnLogin.topAnchor.constraint(equalTo:pwordTxtField.bottomAnchor, constant:20).isActive = true
        btnLogin.leftAnchor.constraint(equalTo:loginContentView.leftAnchor, constant:20).isActive = true
        btnLogin.rightAnchor.constraint(equalTo:loginContentView.rightAnchor, constant:-20).isActive = true
        btnLogin.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    

    // checks if user is logged in
    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    // logs the user in if the account exists
    @objc
    func btnAction() {
        
        // makes sure that there is a non empty email and password field
                guard let email = unameTxtField.text else { return }
                guard let password = pwordTxtField.text else { return }
        
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
                  
                  let tabBarController = TabBarController()
                  tabBarController.modalPresentationStyle = .fullScreen
                  self.present(tabBarController, animated: true, completion: nil)
                  
              }))
              self.present(alertController, animated: true)
          }
        }
    }
}
