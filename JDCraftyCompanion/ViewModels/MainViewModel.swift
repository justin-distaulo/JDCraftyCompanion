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
    
    enum LoadingStep {
        
        case scanning
        case connecting
        case loading
        case none
        
        var text: String {
            
            switch self {
            case .scanning:
                return "Searching for device..."
            case .connecting, .loading:
                return "Connecting to device..."
            default:
                return ""
            }
        }
    }
    
    // Loading
    @Published var isLoading = true
    @Published var devices: [Device] = [] {
        
        didSet {
            
        }
    }
    @Published var loadingText = ""
    
    // Temperature
    @Published var currentTemperature = 0.0
    @Published var targetTemperature = 0
    @Published var boosterTemperature = 0
    
    // Device Info
    @Published var model = ""
    @Published var firmware = ""
    @Published var serialNumber = ""
    @Published var powerOnTime = 0
    @Published private(set) var battery = 0
    
    var fullChargeCapacity = 0 {
        
        didSet {
            self.battery = Int(round(Double(self.remainChargeCapacity) / Double(self.fullChargeCapacity) * 100))
        }
    }
    
    var remainChargeCapacity = 0 {
        
        didSet {
            self.battery = Int(round(Double(self.remainChargeCapacity) / Double(self.fullChargeCapacity) * 100))
        }
    }
    
    var loadingStep: LoadingStep = .none {
        
        didSet {
            self.loadingText = self.loadingStep.text
        }
    }
    
    @ObservedObject var bluetoothModel: BluetoothConnection
    private let bluetoothService: BluetoothService
    
    init() {
        
        // TODO: figure out how to bind self to this model
        let bluetoothConnection = BluetoothConnection()
        
        self.bluetoothModel = bluetoothConnection
        self.bluetoothService = BluetoothService(withBluetoothModel: bluetoothConnection)
    }
    
    func connect(toDevice device: Device) {
        
        self.bluetoothService.connect(toDevice: device)
    }
}
