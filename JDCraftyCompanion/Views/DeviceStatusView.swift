//
//  DeviceStatusView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct DeviceStatusView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            Text("Connected to: \(self.viewModel.connectedDevice?.name ?? "")")
                .font(.callout)
                .foregroundColor(Color.jdText)
            Spacer()
            Text("Battery: \(String(self.viewModel.battery))%")
                .font(.callout)
                .foregroundColor(Color.jdText)
        }
    }
}
