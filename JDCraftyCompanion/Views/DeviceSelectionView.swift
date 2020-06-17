//
//  DeviceSelectionView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit

class DeviceSelectionView: UIView {

    let device: Device
    let mainViewModel: MainViewModel
    
    init(withDevice device: Device, mainViewModel: MainViewModel) {
        self.device = device
        self.mainViewModel = mainViewModel
        super.init(frame: .zero)
        
        self.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        let label = UILabel()
        label.text = device.name
        label.textColor = UIColor.jdText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.link, for: .normal)
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.addSubview(button)
        self.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        mainViewModel.connect(toDevice: device)
    }
}
