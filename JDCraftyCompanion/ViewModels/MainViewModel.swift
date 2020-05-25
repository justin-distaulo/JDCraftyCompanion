//
//  MainViewModel.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-07.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import Combine
import SwiftUI
import CoreBluetooth

class MainViewModel: ObservableObject {
    
    // Loading
    @Published var isLoading = true
    @Published var devices: [Device] = []
    @Published var loadingText = ""
    @Published var state: BluetoothConnection.State = .scanning {
        didSet {
            switch state {
            case .scanning:
                loadingText = "Searching for device..."
            case .connecting:
                loadingText = "Connecting to device..."
            case .connected:
                isLoading = false
            default:
                break
            }
        }
    }
    
    // Temperature
    @Published var currentTemperature = 0.0
    @Published var targetTemperature = 0 {
        didSet {
            boosterTargetTemperature = targetTemperature + boosterAmount
        }
    }
    @Published var boosterTargetTemperature = 0
    
    // Device Info
    @Published private(set) var model = ""
    @Published private(set) var firmware = ""
    @Published private(set) var serialNumber = ""
    @Published private(set) var powerOnTime = 0
    @Published private(set) var battery = 0
    
    private var boosterAmount = 0 {
        didSet {
            boosterTargetTemperature = targetTemperature + boosterAmount
        }
    }
    private var fullChargeCapacity = 0 {
        didSet {
            if remainChargeCapacity != 0 {
                battery = Int(round(Double(remainChargeCapacity) / Double(fullChargeCapacity) * 100))
            }
        }
    }
    private var remainChargeCapacity = 0 {
        didSet {
            if remainChargeCapacity != 0 {
                battery = Int(round(Double(remainChargeCapacity) / Double(fullChargeCapacity) * 100))
            }
        }
    }

    private let bluetoothModel: BluetoothConnection
    private let bluetoothService: BluetoothService
    private var connectedDevice: Device? {
        didSet {
            guard let connectedDevice = connectedDevice else {
                return
            }
            
            subs.append(connectedDevice.$serialNumber.assign(to: \MainViewModel.serialNumber, on: self))
            subs.append(connectedDevice.$model.assign(to: \MainViewModel.model, on: self))
            subs.append(connectedDevice.$firmware.assign(to: \MainViewModel.firmware, on: self))
            subs.append(connectedDevice.$powerOnTime.assign(to: \MainViewModel.powerOnTime, on: self))
            subs.append(connectedDevice.$fullChargeCapacity.assign(to: \MainViewModel.fullChargeCapacity, on: self))
            subs.append(connectedDevice.$remainChargeCapacity.assign(to: \MainViewModel.remainChargeCapacity, on: self))
            subs.append(connectedDevice.$currentTemperature.assign(to: \MainViewModel.currentTemperature, on: self))
            subs.append(connectedDevice.$targetTemperature.assign(to: \MainViewModel.targetTemperature, on: self))
            subs.append(connectedDevice.$boosterAmount.assign(to: \MainViewModel.boosterAmount, on: self))
        }
    }
    private var subs = [AnyCancellable]()
    
    init() {
        let bluetoothConnection = BluetoothConnection()
        
        bluetoothModel = bluetoothConnection
        bluetoothService = BluetoothService(withBluetoothModel: bluetoothConnection)
        
        subs.append(bluetoothConnection.$devices.assign(to: \MainViewModel.devices, on: self))
        subs.append(bluetoothConnection.$state.assign(to: \MainViewModel.state, on: self))
        subs.append(bluetoothConnection.$connectedDevice.assign(to: \MainViewModel.connectedDevice, on: self))
    }
    
    func connect(toDevice device: Device) {
        bluetoothService.connect(toDevice: device)
    }
}
