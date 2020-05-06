//
//  DeviceInfo.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth

class DeviceManager: NSObject {
    
    private struct Services {
        
        enum deviceInfo: String {
            
            case usageTime    = "00000012-4C45-4B43-4942-265A524F5453"
            case model        = "00000022-4C45-4B43-4942-265A524F5453"
            case firmware     = "00000032-4C45-4B43-4942-265A524F5453"
            case serialNumber = "00000052-4C45-4B43-4942-265A524F5453"
            case _bluetooth   = "00000042-4C45-4B43-4942-265A524F5453"
            
            static let uuid = CBUUID(string: "00000002-4C45-4B43-4942-265A524F5453")
            
            var uuid: CBUUID {
                
                return CBUUID(string: self.rawValue)
            }
        }
        
        enum temperatureAndBatteryControl {
            
            case currentTemperature
            case targetTemperature
            case boosterTemperature
            case batteryCapacity
            case ledBrightness
            
            static let uuid = CBUUID(string: "00000001-4C45-4B43-4942-265A524F5453")
            
            var uuid: CBUUID {
                
                switch self {
                case .currentTemperature:
                    return CBUUID(string: "00000011-4C45-4B43-4942-265A524F5453")
                case .targetTemperature:
                    return CBUUID(string: "00000021-4C45-4B43-4942-265A524F5453")
                case .boosterTemperature:
                    return CBUUID(string: "00000031-4C45-4B43-4942-265A524F5453")
                case .batteryCapacity:
                    return CBUUID(string: "00000041-4C45-4B43-4942-265A524F5453")
                case .ledBrightness:
                    return CBUUID(string: "00000051-4C45-4B43-4942-265A524F5453")
                }
            }
        }
            
        enum diagnostics {
            
            case operatingTime
            case powerOnTime
            case fullChargeCapacity
            case remainChargeCapacity
            case dischargeCycles
            case chargeCycles
            case designCapacityAccu
            case _chargerStatus
            case _hardware
            case _pcbVersion
            case _serialNumberHardware
            case _accuStatusRegister
            case _accuStatusRegister2
            case _systemStatusRegister
            case _projectStatus
            case _voltageAccu
            case _voltageMains
            case _voltageHeating
            case _currentAccu
            case _temperaturePT1000
            case _temperaturePT1000Controlled
            case _temperatureNTC
            case _temperatureNTCMin
            case _temperatureNTCMax
            case _deviceField
            case _unknown
            case _securityCode
            case _projectStatusRegister2
            case _resetToDefaultValues
            
            static let uuid = CBUUID(string: "00000003-4C45-4B43-4942-265A524F5453")

            var uuid: CBUUID {
                
                switch self {
                case .operatingTime:
                    return CBUUID(string: "00000013-4C45-4B43-4942-265A524F5453")
                case .powerOnTime:
                    return CBUUID(string: "00000023-4C45-4B43-4942-265A524F5453")
                case .fullChargeCapacity:
                    return CBUUID(string: "00000143-4C45-4B43-4942-265A524F5453")
                case .remainChargeCapacity:
                    return CBUUID(string: "00000153-4C45-4B43-4942-265A524F5453")
                case .dischargeCycles:
                    return CBUUID(string: "00000163-4C45-4B43-4942-265A524F5453")
                case .chargeCycles:
                    return CBUUID(string: "00000173-4C45-4B43-4942-265A524F5453")
                case .designCapacityAccu:
                    return CBUUID(string: "00000183-4C45-4B43-4942-265A524F5453")
                case ._chargerStatus:
                    return CBUUID(string: "000000A3-4C45-4B43-4942-265A524F5453")
                case ._hardware:
                    return CBUUID(string: "00000033-4C45-4B43-4942-265A524F5453")
                case ._pcbVersion:
                    return CBUUID(string: "00000043-4C45-4B43-4942-265A524F5453")
                case ._serialNumberHardware:
                    return CBUUID(string: "00000053-4C45-4B43-4942-265A524F5453")
                case ._accuStatusRegister:
                    return CBUUID(string: "00000063-4C45-4B43-4942-265A524F5453")
                case ._accuStatusRegister2:
                    return CBUUID(string: "00000073-4C45-4B43-4942-265A524F5453")
                case ._systemStatusRegister:
                    return CBUUID(string: "00000083-4C45-4B43-4942-265A524F5453")
                case ._projectStatus:
                    return CBUUID(string: "00000093-4C45-4B43-4942-265A524F5453")
                case ._voltageAccu:
                    return CBUUID(string: "000000B3-4C45-4B43-4942-265A524F5453")
                case ._voltageMains:
                    return CBUUID(string: "000000C3-4C45-4B43-4942-265A524F5453")
                case ._voltageHeating:
                    return CBUUID(string: "000000D3-4C45-4B43-4942-265A524F5453")
                case ._currentAccu:
                    return CBUUID(string: "000000E3-4C45-4B43-4942-265A524F5453")
                case ._temperaturePT1000:
                    return CBUUID(string: "000000F3-4C45-4B43-4942-265A524F5453")
                case ._temperaturePT1000Controlled:
                    return CBUUID(string: "00000103-4C45-4B43-4942-265A524F5453")
                case ._temperatureNTC:
                    return CBUUID(string: "00000113-4C45-4B43-4942-265A524F5453")
                case ._temperatureNTCMin:
                    return CBUUID(string: "00000123-4C45-4B43-4942-265A524F5453")
                case ._temperatureNTCMax:
                    return CBUUID(string: "00000133-4C45-4B43-4942-265A524F5453")
                case ._deviceField:
                    return CBUUID(string: "00000193-4C45-4B43-4942-265A524F5453")
                case ._unknown:
                    return CBUUID(string: "00000193-4C45-4B43-4942-265A524F5453")
                case ._securityCode:
                    return CBUUID(string: "000001B3-4C45-4B43-4942-265A524F5453")
                case ._projectStatusRegister2:
                    return CBUUID(string: "000001C3-4C45-4B43-4942-265A524F5453")
                case ._resetToDefaultValues:
                    return CBUUID(string: "000001D3-4C45-4B43-4942-265A524F5453")
                }
            }
        }
        
        enum errorHandling {
            
            case deviceError
            
            static let uuid = CBUUID(string: "00000004-4C45-4B43-4942-265A524F5453")
            
            var uuid: CBUUID {
                
                switch self {
                case .deviceError:
                    return CBUUID(string: "00000014-4C45-4B43-4942-265A524F5453")
                }
            }
        }
    }
    
    static let shared = DeviceManager()
    var shouldScan = false
    var device: CBPeripheral?
    
    private let manager = CBCentralManager()
    
    required override init() {
        
        super.init()
        self.manager.delegate = self
    }
    
    static var serial: String {
        
        return "fakeserial#"
    }

    static var model: String {
        
        return "FakeModel+"
    }

    static var version: String {
        
        return "v1.fakeVersion"
    }

    static var hours: Int {
        
        return 7
    }
}

extension DeviceManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            
            if self.shouldScan {
                self.manager.scanForPeripherals(withServices: [CBUUID(string: "0x0001")],
                                                options: nil)
            }
        @unknown default:
            print("central.state weird...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name?.uppercased() == "STORZ&BICKEL" {
            
            self.shouldScan = false
            self.device = peripheral
            self.device?.delegate = self
            self.manager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.discoverServices(nil)
    }
}

extension DeviceManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverIncludedServices(nil, for: service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
        guard let includedServices = service.includedServices else {
            return
        }
        
        for includedService in includedServices {
            peripheral.discoverCharacteristics(nil, for: includedService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            peripheral.readValue(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let data = characteristic.value else {
            return
        }
        
        switch Services.deviceInfo(rawValue: characteristic.uuid.uuidString) {
        case .serialNumber, .model:
            print(String(data: data, encoding: .utf8))
        default:
            break
        }
    }
}
