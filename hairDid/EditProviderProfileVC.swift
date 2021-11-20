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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
