//
//  LoadingPage.swift
//  hairDid
//
//  Created by Atlanta Brown on 11/8/21.
//

import UIKit

class AboutVC: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.text = "About the App"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.systemGray6
        return label
    }()
    
    lazy var titleConstraints: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .top, multiplier: 1, constant: 270),
        NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
    ]
    
    private let aboutInfo:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.text = "App for an intro ios class, it's got some work to do but would be an app to help pair braiders and people who would like their hair braided. The provider side is entirely built out, the client side needs the matching functionality implemented. "
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let btnBack:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .clear
        btn.setTitle("Back", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpeg")!)
        
        self.view.addSubview(titleLabel)
        self.view.addConstraints(self.titleConstraints)
        
        self.view.addSubview(aboutInfo)
        self.view.addSubview(btnBack)
        setUpAutoLayout()
    }
    
    func setUpAutoLayout() {
        aboutInfo.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        aboutInfo.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        aboutInfo.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        aboutInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        btnBack.topAnchor.constraint(equalTo:view.topAnchor, constant: 50 ).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant:50).isActive = true
        
    }
}
