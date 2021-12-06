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
    
    // view that'll help organize the constrants added
    private let loginContentView:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    // muted afro logo in backgroung
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"loginBG")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var profileConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.profileImageView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.profileImageView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -20),
    ]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = "Login"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.systemGray6
        return label
    }()
    
    lazy var titleConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 270),
        NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
    ]
    
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        
        self.view.addSubview(profileImageView)
        self.view.addConstraints(profileConstraints)
        
        self.view.addSubview(titleLabel)
        self.view.addConstraints(self.titleConstraints)
        
        loginContentView.addSubview(unameTxtField)
        loginContentView.addSubview(pwordTxtField)
        btnLogin.addTarget(self,
                                action: #selector(btnAction),
                                for: .touchUpInside)
        loginContentView.addSubview(btnLogin)
        
        view.addSubview(loginContentView)
        setUpAutoLayout()
        
        // one user at a time should be logged in to avoid overriding other's info
        if isUserLoggedIn() {
            let alert = UIAlertController(title: "A user is logged in!", message: "Would you like to log out?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                try! Auth.auth().signOut()
                let alertController = UIAlertController(title: nil, message: "Signed out successfully", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
                self.present(alertController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
                
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
    
            }))
            self.present(alert, animated: true)
        }
    }
    
    func setUpAutoLayout(){
        loginContentView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        loginContentView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        loginContentView.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        loginContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor).isActive = true
        unameTxtField.topAnchor.constraint(equalTo:loginContentView.topAnchor, constant:20).isActive = true
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
                alertMessage = "Email address is incorrect. Please try again :)"
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
