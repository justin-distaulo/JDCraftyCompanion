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
                    .foregroundColor(Color.jdText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 24)
            Spacer().frame(maxHeight: 60)
            HStack {
                Text("Serial number:")
                    .foregroundColor(Color.jdText)
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.serialNumber)
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Model:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.model)
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Firmware version:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.firmware)
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Power on time:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.powerOnTime)) hours")
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Battery health:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.batteryHealth))%")
                    .foregroundColor(Color.jdText)
            }
            HStack {
                Text("Charge cycles:")
                    .foregroundColor(Color.jdText)
                    .fontWeight(.bold)
                Spacer()
                Text("\(String(viewModel.chargeCycles))")
                    .foregroundColor(Color.jdText)
            }
            Spacer()
        }
    }
}
