//
//  DeviceInfoViewController.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.jdBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Device Info Screen"
        titleLabel.textColor = UIColor.jdText
        
        view.addSubview(titleLabel)
        view.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12).isActive = true
        view.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        view.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
}
