//
//  ProviderHomePageVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/8/21.
//

import UIKit
import Firebase



class ProviderHomePageVC: UIViewController {
    
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
    
    var dbGalleryImage = ""
    var galleryImage = ""
    var myHairstyle: UIImage? = nil
    var hairStyleImageView: UIImageView? = nil
    
    
    private let providerHomePage:UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = "Client View of your profile"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.systemGray6
        return label
    }()
    
    lazy var titleConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 130),
        NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
    ]
    
    private let providerName:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let businessName:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let website:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let servicesOffered:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let providerFree:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let providerNumber:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let appointmentLocation:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let covidPreferences:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let examplePhoto:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.text = "Photo of Provider's work: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        self.view.addSubview(titleLabel)
        self.view.addConstraints(self.titleConstraints)
    }
    
    // this function reloads every time the screen reappears
    // a previous image is sometimes uploaded and I'm not sure why, seems db updates properly
    // doing this again, I would've used protocols and delegates to get a quick
    // view of the image and in the background, upload it to the database
    override func viewDidAppear(_ animated: Bool) {
        // stalls with spinner while waiting for db value
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // before background task, starting spinner
        activityIndicator.startAnimating()
        getImageFromDatabase()
        
        providerHomePage.addSubview(providerName)
        providerHomePage.addSubview(businessName)
        providerHomePage.addSubview(website)
        providerHomePage.addSubview(servicesOffered)
        providerHomePage.addSubview(providerFree)
        providerHomePage.addSubview(providerNumber)
        providerHomePage.addSubview(appointmentLocation)
        providerHomePage.addSubview(covidPreferences)
        providerHomePage.addSubview(examplePhoto)
        
        view.addSubview(providerHomePage)
        
        getProviderInfoFromDatabase()
        setUpAutoLayout()
    }
    
    // gets image's URL from a snapshot in the database
    func getImageFromDatabase() {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // retrospectively, this would've been done better with protocols & delegates or an observer

        // gets the image from database
        ref.child("users/\(uid)/gallery").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbGalleryImage = snapshot.value as? String ?? ""
            self.galleryImage = self.dbGalleryImage
            print("GALLERY IMAGE in method \(self.galleryImage)")
            self.downloadImage()
        })
    }
    
    // gets the other fields and updates the text
    func getProviderInfoFromDatabase() {
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("uid: \(uid)")
        ref.child("users/\(uid)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderName = snapshot.value as? String ?? ""
            self.providerName.text = "Name: \(self.dbProviderName)"
      
        })
        ref.child("users/\(uid)/businessName").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbBusinessName = snapshot.value as? String ?? ""
            self.businessName.text = "Business Name: \(self.dbBusinessName)"
        })
        
        ref.child("users/\(uid)/website").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbWebsite = snapshot.value as? String ?? ""
            self.website.text = "Website: \(self.dbWebsite)"
        })
        
        ref.child("users/\(uid)/style").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbServicesOffered = snapshot.value as? String ?? ""
            self.servicesOffered.text = "Services offered: \(self.dbServicesOffered)"
        })
        
        ref.child("users/\(uid)/avail").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderFree = snapshot.value as? String ?? ""
            self.providerFree.text = "\(String(describing: self.providerName.text))'s Availability: \(self.dbProviderFree)"
        })
        
        ref.child("users/\(uid)/number").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbProviderNumber = snapshot.value as? String ?? ""
            self.providerNumber.text = "Number: \(self.dbProviderNumber)"
        })
        
        ref.child("users/\(uid)/zipCode").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbAppointmentLocation = snapshot.value as? String ?? ""
            self.appointmentLocation.text = "Appointment Location: \(self.dbAppointmentLocation)"
        })
        
        ref.child("users/\(uid)/covidPreference").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.dbCovidPreferences = snapshot.value as? String ?? ""
            self.covidPreferences.text = "Covid Preferences: \(self.dbCovidPreferences)"
        })
    }
    
    func downloadImage(){
        // stops the activity indicator, we have the variable updated!
        activityIndicator.stopAnimating()
        
        // token issues, 403 error initally
        let galleryImageURL = URL(string: galleryImage)!

        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)

        // download task will download the contents of the URL as a Data object
        let downloadPicTask = session.dataTask(with: galleryImageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading gallery picture: \(e)")
            } else {
                // no errors, 200 response code = success
                if let res = response as? HTTPURLResponse {
                    print("Downloaded gallery picture with response code \(res.statusCode)")
                    //convert data into UIimage to display
                    if let imageData = data {
                        
                        DispatchQueue.main.async{ [self] in
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        self.myHairstyle = image
                        
                            let targetSize = CGSize(width: 250, height: 250)
 
                            let scaledImage = image!.scalePreservingAspectRatio(
                                targetSize: targetSize
                            )
                            self.formatImageAndInfo(image: scaledImage)
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func setUpAutoLayout(){
        providerHomePage.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        providerHomePage.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        providerHomePage.heightAnchor.constraint(equalTo:view.heightAnchor).isActive = true
        providerHomePage.topAnchor.constraint(equalTo: view.topAnchor, constant:100).isActive = true
        providerHomePage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        providerName.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        providerName.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        providerName.heightAnchor.constraint(equalToConstant:20).isActive = true
        providerName.topAnchor.constraint(equalTo: providerHomePage.topAnchor, constant:50).isActive = true
        
        businessName.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        businessName.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        businessName.heightAnchor.constraint(equalToConstant:20).isActive = true
        businessName.topAnchor.constraint(equalTo:providerName.bottomAnchor, constant:20).isActive = true
        
        website.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        website.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        website.heightAnchor.constraint(equalToConstant:20).isActive = true
        website.topAnchor.constraint(equalTo:businessName.bottomAnchor, constant:20).isActive = true
        
        servicesOffered.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        servicesOffered.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        servicesOffered.topAnchor.constraint(equalTo:website.bottomAnchor, constant:20).isActive = true
        
        providerFree.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        providerFree.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        providerFree.topAnchor.constraint(equalTo:servicesOffered.bottomAnchor, constant:20).isActive = true
        
        providerNumber.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        providerNumber.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        providerNumber.heightAnchor.constraint(equalToConstant:20).isActive = true
        providerNumber.topAnchor.constraint(equalTo:providerFree.bottomAnchor, constant:20).isActive = true
        
        appointmentLocation.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        appointmentLocation.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        appointmentLocation.topAnchor.constraint(equalTo:providerNumber.bottomAnchor, constant:20).isActive = true
        
        covidPreferences.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        covidPreferences.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        covidPreferences.topAnchor.constraint(equalTo:appointmentLocation.bottomAnchor, constant:20).isActive = true
        
        examplePhoto.leftAnchor.constraint(equalTo:providerHomePage.leftAnchor, constant:20).isActive = true
        examplePhoto.rightAnchor.constraint(equalTo:providerHomePage.rightAnchor, constant:-20).isActive = true
        examplePhoto.topAnchor.constraint(equalTo:covidPreferences.bottomAnchor, constant:20).isActive = true
    }
    
    // formats the uploaded image
    func formatImageAndInfo(image:UIImage) {
        
        // fade image in
        hairStyleImageView = UIImageView(image: image)
        UIView.transition(with: self.hairStyleImageView!,
                                  duration:5,
                          options: .transitionCrossDissolve,
                          animations: { self.hairStyleImageView?.image = image },
                          completion: nil)
        
        hairStyleImageView!.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        hairStyleImageView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hairStyleImageView!)
        hairStyleImageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hairStyleImageView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 270).isActive = true
    }
}
