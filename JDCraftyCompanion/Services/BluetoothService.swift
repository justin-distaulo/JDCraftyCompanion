//
//  BluetoothService.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth
import Foundation

class BluetoothService: NSObject {
    
    private let bluetoothModel: BluetoothConnection
    private let manager = CBCentralManager()
    private var peripheral: CBPeripheral?
    
    required init(withBluetoothModel bluetoothModel: BluetoothConnection) {
        self.bluetoothModel = bluetoothModel
        super.init()
        manager.delegate = self
    }
    
    func connect(toDevice device: Device) {
        bluetoothModel.state = .connecting
        manager.connect(device.peripheral, options: nil)
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown, .resetting, .unsupported:
            bluetoothModel.state = .error
        case .unauthorized:
            bluetoothModel.state = .unauthorized
        case .poweredOff:
            bluetoothModel.state = .off
        case .poweredOn:
            if peripheral == nil {
                bluetoothModel.state = .scanning
                bluetoothModel.devices.removeAll()
                manager.scanForPeripherals(withServices: [CBUUID(string: "0x0001")],
                                                options: nil)
            }
        @unknown default:
            print("central.state weird...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !bluetoothModel.devices.contains(where: { $0.peripheral == peripheral }) {
            bluetoothModel.devices.append(Device(withPeripheral: peripheral))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        // TODO: Make this less hacky
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (_) in
            guard let self = self else {
                return
            }
            guard let device = self.bluetoothModel.devices.first(where: { $0.peripheral == peripheral }) else {
                self.bluetoothModel.state = .error
                return
            }
            
            self.bluetoothModel.state = .connected
            self.bluetoothModel.connectedDevice = device
        }
    }
}

extension BluetoothService: CBPeripheralDelegate {
    
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
        
        switch Device.Services.temperatureAndBatteryControl(rawValue: characteristic.uuid.uuidString) {
        case .currentTemperature:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            bluetoothModel.connectedDevice?.currentTemperature = Double(intVal) / 10
        case .targetTemperature:
            bluetoothModel.connectedDevice?.targetTemperature = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        case .boosterAmount:
            bluetoothModel.connectedDevice?.boosterAmount = data.withUnsafeBytes { Int($0.load(as: UInt16.self)) } / 10
        default:
            break
        }

        switch Device.Services.info(rawValue: characteristic.uuid.uuidString) {
        case .model:
            bluetoothModel.connectedDevice?.model = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .firmware:
            bluetoothModel.connectedDevice?.firmware = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .serialNumber:
            bluetoothModel.connectedDevice?.serialNumber = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        default:
            break
        }

        switch Device.Services.diagnostics(rawValue: characteristic.uuid.uuidString) {
        case .powerOnTime:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            bluetoothModel.connectedDevice?.powerOnTime = Int(intVal)
        case .fullChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            bluetoothModel.connectedDevice?.fullChargeCapacity = Int(intVal)
        case .remainChargeCapacity:
            let intVal = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            bluetoothModel.connectedDevice?.remainChargeCapacity = Int(intVal)
        case .power:
            // TODO: Maybe figure out what this does?
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
