//
//  TemperatureViewController.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    
    let currentTempLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.jdBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Temperature Screen"
        titleLabel.textColor = UIColor.jdText
        
        view.addSubview(titleLabel)
        view.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12).isActive = true
        view.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        view.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -12).isActive = true
        view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12).isActive = true
        view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12).isActive = true
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        currentTempLabel.text = "N/A"
        currentTempLabel.textColor = UIColor.jdText
        
        stackView.addArrangedSubview(currentTempLabel)
    }
}
