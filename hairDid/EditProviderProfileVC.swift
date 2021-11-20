//
//  EditProviderProfileVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/5/21.
//

import UIKit
import Firebase

class EditProviderProfileVC: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    //var imagePicker:UIImagePickerController

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        // Do any additional setup after loading the view.

        
    }
    
    // after I press the save button, I would like the next screen to be a view controller with the tab bar controller 
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("here")
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
//        let mainTabBarController = storyboard!.instantiateViewController(identifier: "MainTabBarController")
//        mainTabBarController.modalPresentationStyle = .fullScreen
                
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
