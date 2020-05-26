//
//  Device.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-22.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import Combine
import SwiftUI
import CoreBluetooth

class Device: ObservableObject {
    
    // Loading
    @Published var allCharacteristicsLoaded = false
    
    // Temperature
    @Published var currentTemperature = 0.0
    @Published var targetTemperature = 0
    @Published var boosterAmount = 0
    
    // Device Info
    @Published var model = ""
    @Published var firmware = ""
    @Published var serialNumber = ""
    @Published var powerOnTime = 0
    @Published var fullChargeCapacity = 0
    @Published var remainChargeCapacity = 0
    @Published var originalChargeCapacity = 0
    @Published var chargeCycles = 0
    
    let peripheral: CBPeripheral
    var name: String {
        return peripheral.name ?? "unknown"
    }
    var identifier: String {
        return peripheral.identifier.uuidString
    }

    static let servicesToDiscover = [Services.info.uuid, Services.temperatureAndBatteryControl.uuid, Services.diagnostics.uuid, Services.errorHandling.uuid]
    static let characteristicsToLoad = [
        Services.info.uuid: [
            Services.info.model.uuid,
            Services.info.firmware.uuid,
            Services.info.serialNumber.uuid
        ],
        Services.temperatureAndBatteryControl.uuid: [
            Services.temperatureAndBatteryControl.currentTemperature.uuid,
            Services.temperatureAndBatteryControl.targetTemperature.uuid,
            Services.temperatureAndBatteryControl.boosterAmount.uuid,
            Services.temperatureAndBatteryControl.batteryCapacity.uuid,
            Services.temperatureAndBatteryControl.ledBrightness.uuid
        ],
        Services.diagnostics.uuid: [
            Services.diagnostics.powerOnTime.uuid,
            Services.diagnostics.fullChargeCapacity.uuid,
            Services.diagnostics.remainChargeCapacity.uuid,
            Services.diagnostics.originalChargeCapacity.uuid,
            Services.diagnostics.chargeCycles.uuid
        ],
        Services.errorHandling.uuid: [
            Services.errorHandling.deviceError.uuid
        ]
    ]
    
    private var characteristicLoadStatuses = [CBUUID: Bool]() {
        didSet {
            guard allCharacteristicsLoaded == false else {
                return
            }
            
            var allLoaded = true
            for loaded in characteristicLoadStatuses.values {
                if !loaded {
                    allLoaded = false
                    break
                }
            }
            allCharacteristicsLoaded = allLoaded
        }
    }
    
    init(withPeripheral peripheral: CBPeripheral) {
        self.peripheral = peripheral
        
        for characteristicsUuids in Self.characteristicsToLoad.values {
            for uuid in characteristicsUuids {
                characteristicLoadStatuses[uuid] = false
            }
        }
    }
    
    // TODO: Make this model Codable and don't do this
    func update(valueForCharacteristic characteristic: CBCharacteristic) {
        
        guard let data = characteristic.value else {
            return
        }
        
        switch Device.Services.temperatureAndBatteryControl(rawValue: characteristic.uuid.uuidString) {
        case .currentTemperature:
            // This is how you parse a Double
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.currentTemperature = Double(intVal) / 10
        case .targetTemperature:
            // This is how you parse an Int
            self.targetTemperature = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        case .boosterAmount:
            self.boosterAmount = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        default:
            break
        }

        switch Device.Services.info(rawValue: characteristic.uuid.uuidString) {
        case .model:
            // This is how you parse a String
            self.model = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .firmware:
            self.firmware = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .serialNumber:
            self.serialNumber = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        default:
            break
        }

        switch Device.Services.diagnostics(rawValue: characteristic.uuid.uuidString) {
        case .powerOnTime:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.powerOnTime = Int(intVal)
        case .fullChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.fullChargeCapacity = Int(intVal)
        case .remainChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.remainChargeCapacity = Int(intVal)
        case .originalChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.originalChargeCapacity = Int(intVal)
        case .chargeCycles:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.chargeCycles = Int(intVal)
        default:
            break
        }
        
        characteristicLoadStatuses[characteristic.uuid] = true
    }
}

protocol CoreBluetoothIdentifiable: RawRepresentable where RawValue == String {
    
    var uuid: CBUUID { get }
}

extension CoreBluetoothIdentifiable {
    
    var uuid: CBUUID {
        return CBUUID(string: rawValue)
    }
}

extension Device {

    struct Services {
        
        enum info: String, CoreBluetoothIdentifiable {
            
            case model        = "00000022-4C45-4B43-4942-265A524F5453"
            case firmware     = "00000032-4C45-4B43-4942-265A524F5453"
            case serialNumber = "00000052-4C45-4B43-4942-265A524F5453"
            case _usageTime   = "00000012-4C45-4B43-4942-265A524F5453"
            case _bluetooth   = "00000042-4C45-4B43-4942-265A524F5453"
            
            static let uuid = CBUUID(string: "00000002-4C45-4B43-4942-265A524F5453")
        }
        
        enum temperatureAndBatteryControl: String, CoreBluetoothIdentifiable {
            
            case currentTemperature = "00000011-4C45-4B43-4942-265A524F5453"
            case targetTemperature  = "00000021-4C45-4B43-4942-265A524F5453"
            case boosterAmount      = "00000031-4C45-4B43-4942-265A524F5453"
            case batteryCapacity    = "00000041-4C45-4B43-4942-265A524F5453"
            case ledBrightness      = "00000051-4C45-4B43-4942-265A524F5453"
            
            static let uuid = CBUUID(string: "00000001-4C45-4B43-4942-265A524F5453")
        }
            
        enum diagnostics: String, CoreBluetoothIdentifiable {
            
            case powerOnTime                  = "00000023-4C45-4B43-4942-265A524F5453"
            case chargeCycles                 = "00000173-4C45-4B43-4942-265A524F5453"
            case fullChargeCapacity           = "00000143-4C45-4B43-4942-265A524F5453"
            case remainChargeCapacity         = "00000153-4C45-4B43-4942-265A524F5453"
            case originalChargeCapacity       = "00000183-4C45-4B43-4942-265A524F5453"
            case _power                       = "00000063-4C45-4B43-4942-265A524F5453"
            case _dischargeCycles             = "00000163-4C45-4B43-4942-265A524F5453"
            case _operatingTime               = "00000003-4C45-4B43-4942-265A524F5453"
            case _chargerStatus               = "000000A3-4C45-4B43-4942-265A524F5453"
            case _hardware                    = "00000033-4C45-4B43-4942-265A524F5453"
            case _pcbVersion                  = "00000043-4C45-4B43-4942-265A524F5453"
            case _serialNumberHardware        = "00000053-4C45-4B43-4942-265A524F5453"
            case _accuStatusRegister2         = "00000073-4C45-4B43-4942-265A524F5453"
            case _systemStatusRegister        = "00000083-4C45-4B43-4942-265A524F5453"
            case _projectStatus               = "00000093-4C45-4B43-4942-265A524F5453"
            case _voltageAccu                 = "000000B3-4C45-4B43-4942-265A524F5453"
            case _voltageMains                = "000000C3-4C45-4B43-4942-265A524F5453"
            case _voltageHeating              = "000000D3-4C45-4B43-4942-265A524F5453"
            case _currentAccu                 = "000000E3-4C45-4B43-4942-265A524F5453"
            case _temperaturePT1000           = "000000F3-4C45-4B43-4942-265A524F5453"
            case _temperaturePT1000Controlled = "00000103-4C45-4B43-4942-265A524F5453"
            case _temperatureNTC              = "00000113-4C45-4B43-4942-265A524F5453"
            case _temperatureNTCMin           = "00000123-4C45-4B43-4942-265A524F5453"
            case _temperatureNTCMax           = "00000133-4C45-4B43-4942-265A524F5453"
            case _deviceField                 = "00000193-4C45-4B43-4942-265A524F5453"
            case _securityCode                = "000001B3-4C45-4B43-4942-265A524F5453"
            case _projectStatusRegister2      = "000001C3-4C45-4B43-4942-265A524F5453"
            case _resetToDefaultValues        = "000001D3-4C45-4B43-4942-265A524F5453"
            
            static let uuid = CBUUID(string: "00000003-4C45-4B43-4942-265A524F5453")
        }
        
        enum errorHandling: String, CoreBluetoothIdentifiable {
            
            case deviceError = "00000014-4C45-4B43-4942-265A524F5453"
            
            static let uuid = CBUUID(string: "00000004-4C45-4B43-4942-265A524F5453")
            static var characteristicsToDiscover = [deviceError]
        }
    }
}
