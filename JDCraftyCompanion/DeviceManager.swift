//
//  DeviceInfo.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth

class DeviceManager: NSObject {
    
    static let shared = DeviceManager()
    var deviceViewModel: DeviceViewModel?
    var shouldScan = false
    
    private let manager = CBCentralManager()
    private var device: CBPeripheral?
    private var dispatchGroup: DispatchGroup?
    
    required override init() {
        
        super.init()
        self.manager.delegate = self
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
            if self.shouldScan {
                self.deviceViewModel?.isLoading = true
                self.deviceViewModel?.loadingStep = .scanning
                
                self.dispatchGroup = DispatchGroup()
                
                dispatchGroup?.enter()
                self.manager.scanForPeripherals(withServices: [CBUUID(string: "0x0001")],
                                                options: nil)
                
                dispatchGroup?.notify(queue: .main, execute: {
                    self.deviceViewModel?.isLoading = false
                    self.deviceViewModel?.loadingStep = .none
                })
            }
        @unknown default:
            print("central.state weird...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name?.uppercased() == "STORZ&BICKEL" {

            self.deviceViewModel?.loadingStep = .connecting
            self.shouldScan = false
            self.device = peripheral
            self.device?.delegate = self
            self.manager.connect(peripheral, options: nil)
        } else {
            self.dispatchGroup?.leave()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        peripheral.discoverServices(nil)
        
        // This is SO hacky
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
            self.deviceViewModel?.loadingStep = .loading
        }
    }
}

extension DeviceManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else {
            self.dispatchGroup?.leave()
            return
        }
        
        for service in services {
            peripheral.discoverIncludedServices(nil, for: service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        // This is SO hacky
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
            self.dispatchGroup?.leave()
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
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let data = characteristic.value else {
            return
        }
        
        switch Services.temperatureAndBatteryControl(rawValue: characteristic.uuid.uuidString) {
        case .currentTemperature:
            let bytes = [UInt8](data)
            var f: Float = 0
            memcpy(&f, bytes, 2) //todo
            self.deviceViewModel?.currentTemperature = Double(f)
        case .targetTemperature:
            var number: UInt8 = 0
            data.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            self.deviceViewModel?.targetTemperature = Double(number)
        case .boosterTemperature:
            var number: UInt8 = 0
            data.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            self.deviceViewModel?.boosterTemperature = Double(number)
        default:
            break
        }
        
        switch Services.deviceInfo(rawValue: characteristic.uuid.uuidString) {
        case .model:
            self.deviceViewModel?.model = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .firmware:
            self.deviceViewModel?.firmware = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .serialNumber:
            self.deviceViewModel?.serialNumber = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        default:
            break
        }
        
        switch Services.diagnostics(rawValue: characteristic.uuid.uuidString) {
        case .powerOnTime:
        var number: UInt8 = 0
            data.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            self.deviceViewModel?.powerOnTime = Int(number)
        case .fullChargeCapacity:
            var number: UInt8 = 0
            data.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            self.deviceViewModel?.fullChargeCapacity = Int(number)
        case .remainChargeCapacity:
            var number: UInt8 = 0
            data.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            self.deviceViewModel?.remainChargeCapacity = Int(number)
        default:
            break
        }
    }
}
