//
//  TabBarViewController.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit
import Combine

class TabBarViewController: UITabBarController {
    
    private let mainViewModel = MainViewModel()
    private var subs = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempVC = UINavigationController(rootViewController: TemperatureViewController())
        tempVC.tabBarItem = UITabBarItem(title: "Temperature", image: UIImage(systemName: "thermometer"), tag: 0)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        let deviceInfoVC = UINavigationController(rootViewController: DeviceInfoViewController())
        deviceInfoVC.tabBarItem = UITabBarItem(title: "Information", image: UIImage(systemName: "info.circle"), tag: 2)
        
        viewControllers = [tempVC, settingsVC, deviceInfoVC]
        tabBar.tintColor = UIColor.jdText
        tabBar.unselectedItemTintColor = UIColor.jdHighlight
        
        let stateSub = mainViewModel.$state.sink { (state) in
            if state == .scanning && self.presentedViewController == nil {
                let deviceSelectionVC = DeviceSelectionViewController()
                deviceSelectionVC.isModalInPresentation = true
                deviceSelectionVC.mainViewModel = self.mainViewModel
                
                self.present(deviceSelectionVC, animated: true, completion: nil)
            } else if state == .connected && self.mainViewModel.isLoading == false {
                self.dismiss(animated: true, completion: nil)
            }
        }
        subs.append(stateSub)
        
        let isLoadingSub = mainViewModel.$isLoading.sink { (isLoading) in
            if self.mainViewModel.state == .connected && isLoading == false {
                self.dismiss(animated: true, completion: nil)
            }
        }
        subs.append(isLoadingSub)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainViewModel.startScanning()
    }
}
