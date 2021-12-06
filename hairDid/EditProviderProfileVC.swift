//
//  EditProviderProfileVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/5/21.
//

import UIKit
import Firebase

class EditProviderProfileVC: UIViewController, UITextViewDelegate {
    
    var ref: DatabaseReference!
    
    // original data from database
    var dbProviderName = ""
    var dbBusinessName = ""
    var dbWebsite = ""
    var dbServicesOffered = ""
    var dbProviderFree = ""
    var dbProviderNumber = ""
    var dbAppointmentLocation = ""
    var dbCovidPreferences = ""
    
    private let editProviderProfile:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    lazy var sampleStyleImageView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = "Click here to upload a hairstyle picture"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.systemBlue
        
        label.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleSelectGalleryImageView)))
        label.isUserInteractionEnabled = true
        return label
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
    
    private let providerName:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Name"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let businessName:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Business Name"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let website:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Instagram/acuity/ etc"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let servicesOffered:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "What styles do you offer?"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let providerFree:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "What's your availibility like?"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let providerNumber:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Please enter your phone number"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let appointmentLocation:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Do you travel or host? What's your zipcode?"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    private let covidPreferences:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Please enter your covid preferences"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.allowsEditingTextAttributes = true
        txtField.adjustsFontForContentSizeCategory = true
        return txtField
    }()
    
    let saveProviderProfileBtn:UIButton = {
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
        
        editProviderProfile.addSubview(providerName)
        editProviderProfile.addSubview(businessName)
        editProviderProfile.addSubview(website)
        editProviderProfile.addSubview(servicesOffered)
        editProviderProfile.addSubview(providerFree)
        editProviderProfile.addSubview(providerNumber)
        editProviderProfile.addSubview(appointmentLocation)
        editProviderProfile.addSubview(covidPreferences)
        editProviderProfile.addSubview(sampleStyleImageView)
        
        saveProviderProfileBtn.addTarget(self,
                                action: #selector(btnAction),
                                for: .touchUpInside)
        editProviderProfile.addSubview(saveProviderProfileBtn)
        
        view.addSubview(editProviderProfile)
        setUpAutoLayout()
        
        updateFieldsWithValuesFromDatabase()
    }
    
    func updateFieldsWithValuesFromDatabase() {
        // populate text fields with what's in the database for the user
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users/\(uid)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderName = snapshot.value as? String ?? ""
            self.providerName.text = self.dbProviderName
        })
        
        ref.child("users/\(uid)/businessName").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbBusinessName = snapshot.value as? String ?? ""
            self.businessName.text = self.dbBusinessName
        })
        
        ref.child("users/\(uid)/website").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbWebsite = snapshot.value as? String ?? ""
            self.website.text = self.dbWebsite
        })
        
        ref.child("users/\(uid)/style").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbServicesOffered = snapshot.value as? String ?? ""
            self.servicesOffered.text = self.dbServicesOffered
        })
        
        ref.child("users/\(uid)/avail").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderFree = snapshot.value as? String ?? ""
            self.providerFree.text = self.dbProviderFree
        })
        
        ref.child("users/\(uid)/number").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderNumber = snapshot.value as? String ?? ""
            self.providerNumber.text = self.dbProviderNumber
        })
        
        ref.child("users/\(uid)/zipCode").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbAppointmentLocation = snapshot.value as? String ?? ""
            self.appointmentLocation.text = self.dbAppointmentLocation
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

    // user can make changes to the information uploaded
    func setUpAutoLayout(){
        editProviderProfile.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        editProviderProfile.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        editProviderProfile.heightAnchor.constraint(equalTo:view.heightAnchor).isActive = true
        editProviderProfile.topAnchor.constraint(equalTo: view.topAnchor, constant:50).isActive = true
        editProviderProfile.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        editProviderProfile.topAnchor.constraint(equalTo: view.bottomAnchor, constant:50).isActive = true
        
        sampleStyleImageView.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        sampleStyleImageView.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        sampleStyleImageView.heightAnchor.constraint(equalToConstant:50).isActive = true
        sampleStyleImageView.topAnchor.constraint(equalTo: editProviderProfile.topAnchor, constant:50).isActive = true
        
        providerName.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        providerName.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        providerName.heightAnchor.constraint(equalToConstant:50).isActive = true
        providerName.topAnchor.constraint(equalTo: sampleStyleImageView.topAnchor, constant:50).isActive = true
        
        businessName.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        businessName.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        businessName.heightAnchor.constraint(equalToConstant:50).isActive = true
        businessName.topAnchor.constraint(equalTo:providerName.bottomAnchor, constant:20).isActive = true
        
        website.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        website.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        website.heightAnchor.constraint(equalToConstant:50).isActive = true
        website.topAnchor.constraint(equalTo:businessName.bottomAnchor, constant:20).isActive = true
        
        servicesOffered.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        servicesOffered.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        servicesOffered.heightAnchor.constraint(equalToConstant:50).isActive = true
        servicesOffered.topAnchor.constraint(equalTo:website.bottomAnchor, constant:20).isActive = true
        
        providerFree.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        providerFree.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        providerFree.heightAnchor.constraint(equalToConstant:50).isActive = true
        providerFree.topAnchor.constraint(equalTo:servicesOffered.bottomAnchor, constant:20).isActive = true
        
        providerNumber.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        providerNumber.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        providerNumber.heightAnchor.constraint(equalToConstant:50).isActive = true
        providerNumber.topAnchor.constraint(equalTo:providerFree.bottomAnchor, constant:20).isActive = true
        
        appointmentLocation.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        appointmentLocation.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        appointmentLocation.heightAnchor.constraint(equalToConstant:50).isActive = true
        appointmentLocation.topAnchor.constraint(equalTo:providerNumber.bottomAnchor, constant:20).isActive = true
        
        covidPreferences.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        covidPreferences.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        covidPreferences.heightAnchor.constraint(equalToConstant:50).isActive = true
        covidPreferences.topAnchor.constraint(equalTo:appointmentLocation.bottomAnchor, constant:20).isActive = true
        
        saveProviderProfileBtn.topAnchor.constraint(equalTo:covidPreferences.bottomAnchor, constant:20).isActive = true
        saveProviderProfileBtn.leftAnchor.constraint(equalTo:editProviderProfile.leftAnchor, constant:20).isActive = true
        saveProviderProfileBtn.rightAnchor.constraint(equalTo:editProviderProfile.rightAnchor, constant:-20).isActive = true
        saveProviderProfileBtn.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    
    @objc func btnAction() {
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // checks that the value has been changed before updating it in the DB
        if(providerName.text != dbProviderName){
            self.ref.child("users/\(uid)/name").setValue(providerName.text! as NSString)
        }
        if(!businessName.text!.isEmpty){
            self.ref.child("users/\(uid)/businessName").setValue(businessName.text! as NSString)
        }
        if(!website.text!.isEmpty){
            self.ref.child("users/\(uid)/website").setValue(website.text! as NSString)
        }
        if(!servicesOffered.text!.isEmpty){
            self.ref.child("users/\(uid)/style").setValue(servicesOffered.text! as NSString)
        }
        if(!providerFree.text!.isEmpty){
            self.ref.child("users/\(uid)/avail").setValue(providerFree.text! as NSString)
        }
        if(!providerNumber.text!.isEmpty){
            self.ref.child("users/\(uid)/number").setValue(providerNumber.text! as NSString)
        }
        if(!appointmentLocation.text!.isEmpty){
            self.ref.child("users/\(uid)/zipCode").setValue(appointmentLocation.text! as NSString)
        }
        if(!covidPreferences.text!.isEmpty){
            self.ref.child("users/\(uid)/covidPreference").setValue(covidPreferences.text! as NSString)
        }
        
        // popup that tells the user information saved successfullly
        let alertController = UIAlertController(title: nil, message: "Information saved successfully", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
        }))
        self.present(alertController, animated: true)
    }
}
