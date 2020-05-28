//
//  DeviceInfoView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-26.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct DeviceInfoView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Device Info")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Serial number:")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.serialNumber)
            }
            HStack {
                Text("Model:")
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.model)
            }
            HStack {
                Text("Firmware version:")
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.firmware)
            }
            HStack {
                Text("Power on time:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.powerOnTime)) hours")
            }
            HStack {
                Text("Battery:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.battery))%")
            }
            HStack {
                Text("Battery health:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.batteryHealth))%")
            }
            HStack {
                Text("Charge cycles:")
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.chargeCycles))")
            }
            Spacer()
        }
    }
    
    func tabItem() -> some View {
        return self.tabItem {
            VStack {
                Image(systemName: "info.circle")
                Text("Information")
            }
        }
    }
    
    func padding() -> some View {
        return self.padding(.horizontal, 24)
    }
}
