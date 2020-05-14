//
//  DeviceInfo.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth
import Foundation

class DeviceManager: NSObject {
    
    var viewModel: DeviceViewModel
    
    private let manager = CBCentralManager()
    private var device: CBPeripheral?
    
    required init(with viewModel: DeviceViewModel) {

        self.viewModel = viewModel
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
            if self.device == nil {
                self.viewModel.isLoading = true
                self.viewModel.loadingStep = .scanning
                self.viewModel.devices.removeAll()
                self.manager.scanForPeripherals(withServices: [CBUUID(string: "0x0001")],
                                                options: nil)
            }
        @unknown default:
            print("central.state weird...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if !self.viewModel.devices.contains(peripheral) {
            self.viewModel.devices.append(peripheral)
        }
        
//        if peripheral.name?.uppercased() == "STORZ&BICKEL" {
//
//            self.deviceViewModel?.loadingStep = .connecting
//            self.shouldScan = false
//            self.device = peripheral
//            self.device?.delegate = self
//            self.manager.connect(peripheral, options: nil)
//        }
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
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let data = characteristic.value else {
            return
        }
        
        switch DeviceServices.temperatureAndBatteryControl(rawValue: characteristic.uuid.uuidString) {
        case .currentTemperature:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.viewModel.currentTemperature = Double(intVal) / 10
        case .targetTemperature:
            self.viewModel.targetTemperature = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        case .boosterTemperature:
            self.viewModel.boosterTemperature = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        default:
            break
        }
        
        switch DeviceServices.info(rawValue: characteristic.uuid.uuidString) {
        case .model:
            self.viewModel.model = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .firmware:
            self.viewModel.firmware = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .serialNumber:
            self.viewModel.serialNumber = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        default:
            break
        }
        
        switch DeviceServices.diagnostics(rawValue: characteristic.uuid.uuidString) {
        case .powerOnTime:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.viewModel.powerOnTime = Int(intVal)
        case .fullChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.viewModel.fullChargeCapacity = Int(intVal)
        case .remainChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            self.viewModel.remainChargeCapacity = Int(intVal)
        case .power:
//            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            // returns either 0, 32, 32900, 32800 or 32768
            // 32 only occurs on battery
            // 32900, 32800, 32768 only occur while plugged in
            break
        default:
            break
        }
    }
}
