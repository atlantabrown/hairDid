//
//  EditClientProfileVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/5/21.
//

import UIKit
import Firebase

class EditClientProfileVC: UIViewController, UITextViewDelegate {
    
    var ref: DatabaseReference!
    
    // original data from database
    var dbClientName = ""
    var dbClientStyleWanted = ""
    var dbClientFree = ""
    var dbClientNumber = ""
    var dbClientZipcode = ""
    var dbCovidPreferences = ""
    
    private let editClientProfile:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = "Edit Profile"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = UIColor.systemGray6
        return label
    }()
    
    lazy var titleConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 40),
        NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
    ]
    
    private let clientName:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Name"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let clientStyleWanted:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "What styles are you interested in ?"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let clientFree:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "What's your availibility like?"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let clientNumber:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Please enter your phone number"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        return txtField
    }()
    
    private let clientZipcode:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Please enter your zipcode"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        return txtField
    }()
    
    private let covidPreferences:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Please enter your covid preferences"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        return txtField
    }()
    
    let saveClientProfileBtn:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Save Profile", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)

        self.view.addSubview(titleLabel)
        self.view.addConstraints(self.titleConstraints)
        
        editClientProfile.addSubview(clientName)
        editClientProfile.addSubview(clientStyleWanted)
        editClientProfile.addSubview(clientFree)
        editClientProfile.addSubview(clientNumber)
        editClientProfile.addSubview(clientZipcode)
        editClientProfile.addSubview(covidPreferences)
        
        saveClientProfileBtn.addTarget(self,
                                action: #selector(btnAction),
                                for: .touchUpInside)
        editClientProfile.addSubview(saveClientProfileBtn)
        
        view.addSubview(editClientProfile)
        setUpAutoLayout()
        
        // populate text fields with what's in the database for the user
        updateFieldsWithValuesFromDatabase()
    }
    

    func updateFieldsWithValuesFromDatabase() {
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users/\(uid)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbClientName = snapshot.value as? String ?? ""
            self.clientName.text = self.dbClientName
        })
        
        ref.child("users/\(uid)/style").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbClientStyleWanted = snapshot.value as? String ?? ""
            self.clientStyleWanted.text = self.dbClientStyleWanted
        })
        
        ref.child("users/\(uid)/avail").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbClientFree = snapshot.value as? String ?? ""
            self.clientFree.text = self.dbClientFree
        })
        
        ref.child("users/\(uid)/number").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbClientNumber = snapshot.value as? String ?? ""
            self.clientNumber.text = self.dbClientNumber
        })
        
        ref.child("users/\(uid)/zipCode").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbClientZipcode = snapshot.value as? String ?? ""
            self.clientZipcode.text = self.dbClientZipcode
        })
        
        ref.child("users/\(uid)/covidPreference").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbCovidPreferences = snapshot.value as? String ?? ""
            self.covidPreferences.text = self.dbCovidPreferences
        })
    }
    
    
    func setUpAutoLayout(){
        
        editClientProfile.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        editClientProfile.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        editClientProfile.heightAnchor.constraint(equalTo:view.heightAnchor).isActive = true
        editClientProfile.topAnchor.constraint(equalTo: view.topAnchor, constant:50).isActive = true
        editClientProfile.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        editClientProfile.topAnchor.constraint(equalTo: view.bottomAnchor, constant:50).isActive = true

        
       
        clientName.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientName.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientName.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientName.topAnchor.constraint(equalTo:editClientProfile.topAnchor, constant:50).isActive = true
        
        clientStyleWanted.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientStyleWanted.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientStyleWanted.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientStyleWanted.topAnchor.constraint(equalTo:clientName.bottomAnchor, constant:20).isActive = true
        
        clientFree.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientFree.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientFree.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientFree.topAnchor.constraint(equalTo:clientStyleWanted.bottomAnchor, constant:20).isActive = true
        
        clientNumber.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientNumber.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientNumber.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientNumber.topAnchor.constraint(equalTo:clientFree.bottomAnchor, constant:20).isActive = true
        
        clientZipcode.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientZipcode.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientZipcode.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientZipcode.topAnchor.constraint(equalTo:clientNumber.bottomAnchor, constant:20).isActive = true
        
        covidPreferences.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        covidPreferences.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        covidPreferences.heightAnchor.constraint(equalToConstant:50).isActive = true
        covidPreferences.topAnchor.constraint(equalTo:clientZipcode.bottomAnchor, constant:20).isActive = true
        
        saveClientProfileBtn.topAnchor.constraint(equalTo:covidPreferences.bottomAnchor, constant:20).isActive = true
        saveClientProfileBtn.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        saveClientProfileBtn.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        saveClientProfileBtn.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    
    @objc
    func btnAction() {
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // checks that the value has been changed before updating it in the DB
        if(!clientName.text!.isEmpty){
            self.ref.child("users/\(uid)/name").setValue(clientName.text! as NSString)
        }
        if(!clientStyleWanted.text!.isEmpty){
            self.ref.child("users/\(uid)/style").setValue(clientStyleWanted.text! as NSString)
        }
        if(!clientFree.text!.isEmpty){
            self.ref.child("users/\(uid)/avail").setValue(clientFree.text! as NSString)
        }
        if(!clientNumber.text!.isEmpty){
            self.ref.child("users/\(uid)/number").setValue(clientNumber.text! as NSString)
        }
        if(!clientZipcode.text!.isEmpty){
            self.ref.child("users/\(uid)/zipCode").setValue(clientZipcode.text! as NSString)
        }
        if(!covidPreferences.text!.isEmpty){
            self.ref.child("users/\(uid)/covidPreference").setValue(covidPreferences.text! as NSString)
        }
        
        // popup that tells the user information saved
        let alertController = UIAlertController(title: nil, message: "Information saved successfully", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
        }))
        self.present(alertController, animated: true)
    }
}
