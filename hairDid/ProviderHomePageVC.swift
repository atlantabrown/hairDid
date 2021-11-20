//
//  ProviderHomePageVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/8/21.
//

import UIKit
import Firebase

class ProviderHomePageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        // Do any additional setup after loading the view.
        
        // determine the current user's account type and configure the tabs to include
        // the appropriate user's home page and settings 
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
            if (accountType == "client"){
                self.tabBarController?.viewControllers?.remove(at: 1)
            }
            if (accountType == "provider"){
                self.tabBarController?.viewControllers?.remove(at: 0)
            }
        })
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
