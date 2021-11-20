//
//  TabBarController.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/19/21.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var userIsClient = false
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
            //print("account type \(accountType)")
            if (accountType == "provider"){
                print("HERE")
                userIsClient = false
            }
            if (accountType == "client"){
                userIsClient = true
            }
        })
        
        print("DO WE GET HERE")
        let item1 = (userIsClient) ? ClientHomePageVC() : ProviderHomePageVC()
        let icon1 = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        item1.tabBarItem = icon1
        
        let item2 = SettingsVC()
        let icon2 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]
        self.viewControllers = controllers
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
