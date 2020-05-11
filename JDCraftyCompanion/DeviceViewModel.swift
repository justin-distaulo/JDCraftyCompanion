//
//  DeviceViewModel.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-07.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//


import Combine
import SwiftUI

class DeviceViewModel: ObservableObject {
    
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
    @Published var isLoading = false
    @Published var loadingText = ""
    
    // Temperature
    @Published private(set) var currentTemperature = 0.0
    @Published var targetTemperature = 0.0
    @Published var boosterTemperature = 0.0
    
    // Device Info
    @Published var model = ""
    @Published var firmware = ""
    @Published var serialNumber = ""
    @Published var powerOnTime = 0
    @Published private(set) var battery = 0
    
    private var rawTempCount = 0
    private var rawTempThreshold = 10.0
    var rawTemperature = 0.0 {
        
        willSet {
            let difference = newValue - rawTemperature
            if difference.magnitude <= rawTempThreshold {
                rawTempCount += 1
            }
            if rawTempCount > 3 {
                rawTempCount = 0
                self.currentTemperature = newValue
            }
        }
    }
    
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
    
    init() {

        DeviceManager.shared.shouldScan = true
        DeviceManager.shared.deviceViewModel = self
    }
}
