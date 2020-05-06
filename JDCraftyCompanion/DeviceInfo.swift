//
//  DeviceInfo.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import CoreBluetooth

class DeviceManager: NSObject {
    
    private enum Features {
        
        case
        
    }
    /*
    # Temperature and Battery Control (00000001-4C45-4B43-4942-265A524F5453)

    - Current Temperature (00000011-4C45-4B43-4942-265A524F5453)
    - Integer
    - Current temperature in ºC * 10 (ie 1822 is 182.2ºC)

    - Target Temperature (00000021-4C45-4B43-4942-265A524F5453)
    - Integer (Read Write)
    - Set temperature in ºC * 10 (ie 1822 is 182.2ºC)

    - Booster Temperature (00000031-4C45-4B43-4942-265A524F5453)
    - Integer (Read Write)
    - Number of ºC * 10 to boost set temp (ie 150 is 15.0ºC)

    - Battery Capacity (00000041-4C45-4B43-4942-265A524F5453)
    - Integer
    - Percent of battery remaining (ie 76 is 76% battery remaining)

    - LED Brightness (00000051-4C45-4B43-4942-265A524F5453)
    - Integer (Read Write)
    - Min 0 (off) Max 100


    # Device Info (00000002-4C45-4B43-4942-265A524F5453)

    - Usage Time (00000012-4C45-4B43-4942-265A524F5453)
    - Integer
    - Unit unknown. Mine returns 20 while app says I have 3 hours of usage.

    - Model (00000022-4C45-4B43-4942-265A524F5453)
    - UTF8 String
    - Returns "Crafty"

    - Firmware (00000032-4C45-4B43-4942-265A524F5453")
    - UTF8 String
    - Mine returns "V02.04"

    - Bluetooth (00000042-4C45-4B43-4942-265A524F5453)
    - Binary Data. Likely a UUID
    - Meaning unknown. Very likely the UUID for the Crafty's bluetooth chip

    - Serial Number (00000052-4C45-4B43-4942-265A524F5453)
    - UTF8 String
    - Unit serial number in form "CY00____00"


    # Diagnostics (00000003-4C45-4B43-4942-265A524F5453) (Note: this is where things get interesting. :)

    - Operating Time (00000013-4C45-4B43-4942-265A524F5453)
    - Integer
    - Appears to be the same as Device Info's Usage Time

    - Power on Time (00000023-4C45-4B43-4942-265A524F5453)
    - Integer
    - Number of hours unit has been used.

    - Hardware (00000033-4C45-4B43-4942-265A524F5453)
    - Binary Data (likely a UUID)
    - Very likely a unique id for the Device

    - PCB Version (00000043-4C45-4B43-4942-265A524F5453)
    - UTF8 String?
    - Not sure what this is. Mine is just a bunch of question marks.

    - Serial Number Hardware (00000053-4C45-4B43-4942-265A524F5453)
    - UTF8 String
    - Use unknown. Possibly the serial number for the logic board?

    - Accu Status Register (00000063-4C45-4B43-4942-265A524F5453)
    - Unknown type (mine says 0)
    - Unknown use

    - Accu Status Register 2 (00000073-4C45-4B43-4942-265A524F5453)
    - Unknown type (mine says 0)
    - Unknown use

    - System Status Register (00000083-4C45-4B43-4942-265A524F5453)
    - Integer?
    - Most likely a failure code used to diagnose misbehaving units

    - Project Status (00000093-4C45-4B43-4942-265A524F5453)
    - Integer
    - Not sure what this means. Mine says 1024

    - Charger Status (000000A3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Some sort of status code about charging. Returns 0 wile on battery, 2 while charging. I bet the 2 is the charge level or something.

    - Voltage Accu (000000B3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Voltage of something. Mine is 3792 or 3791

    - Voltage Mains (000000C3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Voltage of something. Stays in the 340s for me

    - Voltage Heating (000000D3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Voltage of the heating element? Seems to be the same as Voltage Accu

    - Current Accu (000000E3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Unknown. Stays around 60,000. Drops to 0 when turned off.

    - Temperature PT1000 (000000F3-4C45-4B43-4942-265A524F5453)
    - Integer
    - Likely the raw data coming off a PT1000 thermometer somewhere in the Crafty. Returns in high 1900s while heated to default 180ºC setpoint

    - Temperature PT1000 Controlled (00000103-4C45-4B43-4942-265A524F5453)
    - Integer
    - Something else coming off a PT1000 thermometer. Returns 1833 while at 180ºC

    - Temperature NTC (00000113-4C45-4B43-4942-265A524F5453)
    - Integer
    - Something coming off an NTC Thermistor.

    - Temperature NTC Min (00000123-4C45-4B43-4942-265A524F5453)
    - Integer
    - Minimum value for the NTC Thermistor. Mine returns 194

    - Temperature Max NTC (00000133-4C45-4B43-4942-265A524F5453)
    - Integer
    - Maximum value for the NTC Thermistor. Mine returns 607

    - Full Charge Capacity (00000143-4C45-4B43-4942-265A524F5453)
    - Integer
    - Actual mAh for battery on a full charge

    - Remain Charge Capacity (00000153-4C45-4B43-4942-265A524F5453)
    - Integer
    - mAh remaining on battery

    - Discharge Cycles (00000163-4C45-4B43-4942-265A524F5453)
    - Integer
    - Number of times the batter has been drained

    - Charge Cycles (00000173-4C45-4B43-4942-265A524F5453)
    - Integer
    - Number of times the battery has been charged

    - Design Capacity Accu (00000183-4C45-4B43-4942-265A524F5453)
    - Integer
    - mAh battery had when new (reports 2650 for me).

    - Device Field (00000193-4C45-4B43-4942-265A524F5453)
    - UTF8 String?
    - Returns a bunch of question marks for me

    - Unknown. Not defined in Android App (00000193-4C45-4B43-4942-265A524F5453)
    - Unknown (Write Only)
    - No idea whit this is

    - Security Code (000001B3-4C45-4B43-4942-265A524F5453)
    - Unknown (Write Only)
    - Was hoping this would give up the code for the advanced settings thing but it's write only. I suppose this doc makes that screen a bit less important though. ;)

    - Project Status Register 2 (000001C3-4C45-4B43-4942-265A524F5453)
    - Integer (Read Write)
    - Mine says 2. Not sure what this means.

    - Reset to Default Values (000001D3-4C45-4B43-4942-265A524F5453)
    - Unknown (Write Only)
    - Obviously there is some sort of magic code you can send here to reset things. No idea what it could be.


    # Error Handling (00000004-4C45-4B43-4942-265A524F5453)

    - Device Error (00000014-4C45-4B43-4942-265A524F5453)
    - Integer
    - Probably a diagnostic code for the service center. Mine says 0.
    */
    
    private static let shared = DeviceManager()
    private let manager = CBCentralManager()
    private var device: CBPeripheral?
    
    required override init() {
        
        super.init()
        self.manager.delegate = self
    }
    
    static func scanForDevices() {

        self.shared.manager.scanForPeripherals(withServices: nil,
                                               options: nil)
    }
    
    static var serial: String {
        
        return "CY-#FAKESERIAL"
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
        @unknown default:
            print("central.state weird...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name?.uppercased() == "STORZ&BICKEL" {
            
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
        
        
    }
}
