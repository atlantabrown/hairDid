//
//  ClientHomePageVC.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/8/21.
//

import UIKit
import Firebase

class ClientHomePageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Look through avaliable providers"
        self.view.addSubview(label)
        
    }
}
