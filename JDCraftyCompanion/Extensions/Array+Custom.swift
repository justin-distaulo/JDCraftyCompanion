//
//  Array+Custom.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-29.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Array where Element: CBIdentifiable {
    
    var uuids: [CBUUID] {
        return self.map({ $0.uuid })
    }
}
