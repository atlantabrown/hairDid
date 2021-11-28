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
    
    private let editClientProfile:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    private let screenTitle:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = "Edit Profile"
        return label
    }()
    
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
        //self.navigationItem.title = "The title"
        // Do any additional setup after loading the view.
        
        // used to update the database with information
//        let user = Auth.auth().currentUser
//        let uid = user!.uid
//        let ref = Database.database().reference()
        
        
        editClientProfile.addSubview(screenTitle)
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
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
    
    // we want to be able to save the profile
    // we want to be able to make changes to the profile
    
    
    func setUpAutoLayout(){
        
        //let window = UIApplication.shared.windows.first
        
        editClientProfile.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        editClientProfile.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        editClientProfile.heightAnchor.constraint(equalToConstant: view.frame.height * 0.7).isActive = true
        editClientProfile.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        screenTitle.topAnchor.constraint(equalTo:editClientProfile.topAnchor).isActive = true
        screenTitle.topAnchor.constraint(equalTo:editClientProfile.topAnchor, constant:40).isActive = true
        screenTitle.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        screenTitle.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        screenTitle.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        clientName.leftAnchor.constraint(equalTo:editClientProfile.leftAnchor, constant:20).isActive = true
        clientName.rightAnchor.constraint(equalTo:editClientProfile.rightAnchor, constant:-20).isActive = true
        clientName.heightAnchor.constraint(equalToConstant:50).isActive = true
        clientName.topAnchor.constraint(equalTo:screenTitle.bottomAnchor, constant:20).isActive = true
        
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
            self.ref.child("users/\(uid)/name").setValue(clientName.text as! NSString)
        }
        if(!clientStyleWanted.text!.isEmpty){
            self.ref.child("users/\(uid)/style").setValue(clientStyleWanted.text as! NSString)
        }
        if(!clientFree.text!.isEmpty){
            self.ref.child("users/\(uid)/avail").setValue(clientFree.text as! NSString)
        }
        if(!clientNumber.text!.isEmpty){
            self.ref.child("users/\(uid)/number").setValue(clientNumber.text as! NSString)
        }
        if(!clientZipcode.text!.isEmpty){
            self.ref.child("users/\(uid)/zipCode").setValue(clientZipcode.text as! NSString)
        }
        if(!covidPreferences.text!.isEmpty){
            self.ref.child("users/\(uid)/covidPreference").setValue(covidPreferences.text as! NSString)
        }
        
        // some alert that information was saved correctly 
        
        // takes the user to the tab bar controller home page next
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
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
