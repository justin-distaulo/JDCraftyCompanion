//
//  Services.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-07.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth

protocol CoreBluetoothIdentifiable: RawRepresentable where RawValue == String {
    
    var uuid: CBUUID { get }
}

extension CoreBluetoothIdentifiable {
    
    var uuid: CBUUID {
        
        return CBUUID(string: self.rawValue)
    }
}

struct Services {
    
    enum deviceInfo: String, CoreBluetoothIdentifiable {
        
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
        case boosterTemperature = "00000031-4C45-4B43-4942-265A524F5453"
        case batteryCapacity    = "00000041-4C45-4B43-4942-265A524F5453"
        case ledBrightness      = "00000051-4C45-4B43-4942-265A524F5453"
        
        static let uuid = CBUUID(string: "00000001-4C45-4B43-4942-265A524F5453")
    }
        
    enum diagnostics: String, CoreBluetoothIdentifiable {
        
        case powerOnTime                  = "00000023-4C45-4B43-4942-265A524F5453"
        case fullChargeCapacity           = "00000143-4C45-4B43-4942-265A524F5453"
        case remainChargeCapacity         = "00000153-4C45-4B43-4942-265A524F5453"
        case dischargeCycles              = "00000163-4C45-4B43-4942-265A524F5453"
        case chargeCycles                 = "00000173-4C45-4B43-4942-265A524F5453"
        case designCapacityAccu           = "00000183-4C45-4B43-4942-265A524F5453"
        case _operatingTime               = "00000003-4C45-4B43-4942-265A524F5453"
        case _chargerStatus               = "000000A3-4C45-4B43-4942-265A524F5453"
        case _hardware                    = "00000033-4C45-4B43-4942-265A524F5453"
        case _pcbVersion                  = "00000043-4C45-4B43-4942-265A524F5453"
        case _serialNumberHardware        = "00000053-4C45-4B43-4942-265A524F5453"
        case _accuStatusRegister          = "00000063-4C45-4B43-4942-265A524F5453"
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
    }
}
