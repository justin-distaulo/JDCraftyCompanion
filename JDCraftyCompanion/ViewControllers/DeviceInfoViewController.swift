//
//  DeviceInfoViewController.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-16.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UIViewController {
    
    var mainViewModel: MainViewModel?
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.jdBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeviceInfoCell.self, forCellReuseIdentifier: DeviceInfoCell.reuseIdentifier)
        
        view.addSubview(tableView)
        view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    }
}

extension DeviceInfoViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Device.Service.info.characteristics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceInfoCell.reuseIdentifier, for: indexPath) as? DeviceInfoCell,
            let device = mainViewModel?.connectedDevice else {
            return UITableViewCell()
        }
        
        let characteristic = Device.Characteristic.allCases[indexPath.row]
        let value: String
        switch characteristic {
        case .model:
            value = device.model
        case .serialNumber:
            value = device.serialNumber
        case .firmware:
            value = device.firmware
        default:
            value = "Invalid..."
        }
        
        cell.configure(withTitle: "\(characteristic.name):", value: value)
        
        return cell
    }
}
