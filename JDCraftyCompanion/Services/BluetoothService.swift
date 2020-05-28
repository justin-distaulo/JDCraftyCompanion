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
            print("For some reason the bluetooth state is weird. This is the current value: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !bluetoothModel.devices.contains(where: { $0.peripheral == peripheral }) {
            bluetoothModel.devices.append(Device(withPeripheral: peripheral))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let device = self.bluetoothModel.devices.first(where: { $0.peripheral == peripheral }) else {
            self.bluetoothModel.state = .error
            return
        }

        self.peripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(Device.Service.uuids)
                
        bluetoothModel.state = .connected
        bluetoothModel.connectedDevice = device
    }
}

extension BluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(Device.Service(rawValue: service.uuid.uuidString)?.characteristics.uuids,
                                               for: service)
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
        guard let connectedDevice = bluetoothModel.connectedDevice,
            let data = characteristic.value,
            let characteristic = Device.Characteristic(rawValue: characteristic.uuid.uuidString) else {
            return
        }

        connectedDevice.updateProperty(for: characteristic, with: data)
    }
}
