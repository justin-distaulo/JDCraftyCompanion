//
//  BluetoothConnection.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-22.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import Combine
import SwiftUI
import CoreBluetooth

class BluetoothConnection: ObservableObject {
    
    enum State {
        case error
        case off
        case unauthorized
        case scanning
        case connecting
        case connected
    }
    
    @Published var state: State = .scanning
    @Published var devices: [Device] = []
    @Published var connectedDevice: Device?
}
