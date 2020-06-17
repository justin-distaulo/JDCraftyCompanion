//
//  DeviceSelectionViewController.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit
import Combine
import Lottie

class DeviceSelectionViewController: UIViewController {
    
    var mainViewModel: MainViewModel?
    
    private var subs = [AnyCancellable]()
    private let animationView = AnimationView(animation: Animation.named("hamster"))
    private let statusLabel = UILabel()
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.jdBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Connect to a device"
        titleLabel.textColor = UIColor.jdText
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        view.addSubview(titleLabel)
        view.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -40).isActive = true
        view.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12).isActive = true
        view.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        view.addSubview(animationView)
        view.centerXAnchor.constraint(equalTo: animationView.centerXAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 72).isActive = true
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.jdText
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        statusLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        view.addSubview(statusLabel)
        view.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -12).isActive = true
        view.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 12).isActive = true
        statusLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 32).isActive = true
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        view.addSubview(stackView)
        view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -24).isActive = true
        view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 24).isActive = true
        stackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationView.play()

        guard let mainViewModel = mainViewModel else { return }
        
        let devicesSub = mainViewModel.$devices.sink { (devices) in
            let oldDevices = self.stackView.arrangedSubviews.compactMap({ return ($0 as? DeviceSelectionView)?.device })
            let newDevices = devices.filter { (device) -> Bool in
                return !oldDevices.contains(where: { $0.name == device.name })
            }
            
            for device in newDevices {
                self.stackView.addArrangedSubview(DeviceSelectionView(withDevice: device, mainViewModel: mainViewModel))
            }
        }
        self.subs.append(devicesSub)
        
        let stateSub = mainViewModel.$state.sink { (state) in
            switch state {
            case .scanning:
                self.statusLabel.text = "Scanning for devices..."
            case .connecting:
                self.statusLabel.text = "Connecting to device..."
            case .connected:
                self.statusLabel.text = "Connected!"
            case .off:
                self.statusLabel.text = "Please turn on Bluetooth!"
            case .unauthorized:
                self.statusLabel.text = "Please authorize this app to use Bluetooth!"
            case .error:
                self.statusLabel.text = "Uh-oh, spaghetti-o! Something is wrong..."
            }
        }
        self.subs.append(stateSub)
    }
}
