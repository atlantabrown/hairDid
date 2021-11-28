//
//  TabBarController.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/19/21.
//

import UIKit
import Firebase

class User {
    var accountType: String = ""
}

var userIsClient:Bool = false
// loading indicator
var activityIndicator = UIActivityIndicatorView(style: .large)

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // add spinner to view
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // before background task, starting spinner
        activityIndicator.startAnimating()
        
        // callback will allow us to hook the data back in and respond to completion event
        fetchUserType() { (userIsClient) in
            self.showData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showData(){
        // stops the activity indicator, we have the variable updated!
        activityIndicator.stopAnimating()
        //print("IS USER CLIENT")
        let item1 = (userIsClient) ? ClientHomePageVC() : ProviderHomePageVC()
        let icon1 = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        item1.tabBarItem = icon1
        
        let item2 = SettingsVC()
        let icon2 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]
        self.viewControllers = controllers
    }
  
    
    func fetchUserType(userCompletionHandler: @escaping (Bool) -> Void) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        var accountType = ""
        let ref = Database.database().reference()
        ref.child("users/\(uid)/accountType").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return
          }
          accountType = snapshot.value as? String ?? "Unknown"
            userIsClient = (accountType == "client")
            userCompletionHandler(userIsClient)
        })
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
