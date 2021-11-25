//
//  EditClientProfileVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/5/21.
//

import UIKit
import Firebase

class EditClientProfileVC: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var clientNameLabel: UITextField!
    @IBOutlet weak var clientBioTextView: UITextView!
    @IBOutlet weak var clientEmailLabel: UITextField!
    @IBOutlet weak var clientNumberLabel: UITextField!
    @IBOutlet weak var clientContactPreferenceLabel: UITextField!
    @IBOutlet weak var clientZipcodeLabel: UITextField!
    @IBOutlet weak var clientCovidPreferenceLabel: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        // Do any additional setup after loading the view.
        clientBioTextView.delegate = self
        clientBioTextView.layer.cornerRadius = 5.0
        clientBioTextView.isEditable = true
        
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let ref = Database.database().reference()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
        }

    func textViewDidEndEditing(_ textView: UITextView) {
         if textView.text.isEmpty {
             textView.text = "Write your comment."
             textView.textColor = UIColor.systemGray6
         }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
    
    // we want to allow the uploading of a profile picture
    // we want to be able to save the profile
    // we want to be able to make changes to the profile
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
