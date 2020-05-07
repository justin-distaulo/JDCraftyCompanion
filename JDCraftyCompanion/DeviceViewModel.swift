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
    
    // Device Info
    @Published var model = ""
    @Published var firmware = ""
    @Published var serialNumber = ""
    
    // Diagnostics
    @Published var powerOnTime: String = ""
    
    
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
