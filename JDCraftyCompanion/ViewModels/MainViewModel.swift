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
    @Published var isLoading = false
    @Published var devices: [Device] = []
    @Published var loadingText = ""
    @Published var state: BluetoothConnection.State = .off {
        didSet {
            switch state {
            case .scanning:
                isLoading = true
                loadingText = "Searching for device..."
            case .connecting:
                isLoading = true
                loadingText = "Connecting to device..."
            default:
                isLoading = false
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
    @Published private(set) var batteryHealth = 0
    @Published private(set) var chargeCycles = 0
    
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
            if originalChargeCapacity != 0 {
                batteryHealth = Int(round(Double(fullChargeCapacity) / Double(originalChargeCapacity) * 100))
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
    private var originalChargeCapacity = 0 {
        didSet {
            if originalChargeCapacity != 0 {
                batteryHealth = Int(round(Double(fullChargeCapacity) / Double(originalChargeCapacity) * 100))
            }
        }
    }
    
    var connectedDevice: Device? {
        didSet {
            guard let connectedDevice = connectedDevice else {
                return
            }
            
            subs.append(connectedDevice.$allCharacteristicsLoaded.map({ !$0 }).assign(to: \.isLoading, on: self))
            subs.append(connectedDevice.$serialNumber.assign(to: \.serialNumber, on: self))
            subs.append(connectedDevice.$model.assign(to: \.model, on: self))
            subs.append(connectedDevice.$firmware.assign(to: \.firmware, on: self))
            subs.append(connectedDevice.$powerOnTime.assign(to: \.powerOnTime, on: self))
            subs.append(connectedDevice.$fullChargeCapacity.assign(to: \.fullChargeCapacity, on: self))
            subs.append(connectedDevice.$remainChargeCapacity.assign(to: \.remainChargeCapacity, on: self))
            subs.append(connectedDevice.$originalChargeCapacity.assign(to: \.originalChargeCapacity, on: self))
            subs.append(connectedDevice.$chargeCycles.assign(to: \.chargeCycles, on: self))
            subs.append(connectedDevice.$currentTemperature.map({ Double($0) / 10 }).assign(to: \.currentTemperature, on: self))
            subs.append(connectedDevice.$targetTemperature.map({ $0 / 10 }).assign(to: \.targetTemperature, on: self))
            subs.append(connectedDevice.$boosterAmount.map({ $0 / 10 }).assign(to: \.boosterAmount, on: self))
        }
    }

    private let bluetoothModel: BluetoothConnection
    private let bluetoothService: BluetoothService
    private var subs = [AnyCancellable]()
    
    init() {
        let bluetoothConnection = BluetoothConnection()
        
        bluetoothModel = bluetoothConnection
        bluetoothService = BluetoothService(withBluetoothModel: bluetoothConnection)
        
        subs.append(bluetoothConnection.$devices.assign(to: \MainViewModel.devices, on: self))
        subs.append(bluetoothConnection.$state.assign(to: \MainViewModel.state, on: self))
        subs.append(bluetoothConnection.$connectedDevice.assign(to: \MainViewModel.connectedDevice, on: self))
    }
    
    func startScanning() {
        bluetoothService.startScanning()
    }
    
    func connect(toDevice device: Device) {
        bluetoothService.connect(toDevice: device)
    }
}
