//
//  SettingsVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/8/21.
//

import UIKit
import Firebase


struct Section {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (()-> Void)
}

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        //table.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        return table
    }()
    
    // array of models
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserType() { (userIsClient) in
            // stop animation
            // tell
        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        configure()
        
//        // add spinner to view
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(activityIndicator)
//        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//        // before background task, starting spinner
//        activityIndicator.startAnimating()
        
        
        
        title = "settings"
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        
        
    }
    
    func configure() {
        // stops the activity indicator, we have the variable updated!
        //activityIndicator.stopAnimating()
        models.append(Section(title: "Settings", options: [
        ]))
        
        models.append(Section(title: "General", options: [
            SettingsOption(title: "Wifi", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemBlue) {
                print("tapped first cell")
            },
            SettingsOption(title: "Font Size", icon: UIImage(systemName: "fontSize"), iconBackgroundColor: .systemPink) {
                
            },
            SettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemGreen) {
                
            },
            SettingsOption(title: "Dark Mode", icon: UIImage(systemName: "moon.stars"), iconBackgroundColor: .systemGray4) {
                
            },
        ]))
        
        models.append(Section(title: "Information", options: [
            SettingsOption(title: "About App", icon: UIImage(systemName: "information"), iconBackgroundColor: .systemBlue) {
                print("tapped first cell another section")
            },
            SettingsOption(title: "Edit Profile Information", icon: UIImage(systemName: "profile"), iconBackgroundColor: .systemPink) {
//                let tabBarController = TabBarController()
//                tabBarController.modalPresentationStyle = .fullScreen
//                self.present(tabBarController, animated: true, completion: nil)
               
                
                print("inside settings: user is client? \(userIsClient)")
                
                    if(userIsClient){
                        let editClientProfileVC = EditClientProfileVC()
                        editClientProfileVC.modalPresentationStyle = .fullScreen
                        self.present(editClientProfileVC, animated: true)
                    }else{
                        let editProviderProfileVC = EditProviderProfileVC()
                        editProviderProfileVC.modalPresentationStyle = .fullScreen
                        self.present(editProviderProfileVC, animated: true)
                    }
                
            },
            SettingsOption(title: "Logout of Account", icon: UIImage(systemName: "questionMark"), iconBackgroundColor: .systemGreen) {
                try! Auth.auth().signOut()
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            },
        ]))
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
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier,
            for: indexPath
        ) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        //cell.backgroundColor = .clear
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
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
