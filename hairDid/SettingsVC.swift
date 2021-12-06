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
        return table
    }()
    
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserType() { (userIsClient) in

        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        configure()
        
        title = "settings"
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        
    }
    
    func configure() {
        models.append(Section(title: "Settings", options: [
        ]))
        
        models.append(Section(title: "General", options: [
           
            SettingsOption(title: "Edit Profile Information", icon: UIImage(systemName: "person"), iconBackgroundColor: .systemGreen) {

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
            SettingsOption(title: "Sign Out", icon: UIImage(systemName: "pip.exit"), iconBackgroundColor: .systemPink) {
                try! Auth.auth().signOut()
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            },
        ]))
        
        models.append(Section(title: "Information", options: [
            SettingsOption(title: "Share with your friends!", icon: UIImage(systemName: "square.and.arrow.up"), iconBackgroundColor: .systemMint) {
                let items = ["Check out HairDid! This app helps matches you with a hair braider or client."]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            },
            SettingsOption(title: "About App", icon: UIImage(systemName: "info.circle"), iconBackgroundColor: .systemBlue) {
                let aboutVC = AboutVC()
                aboutVC.modalPresentationStyle = .fullScreen
                self.present(aboutVC, animated: true)
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
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}
