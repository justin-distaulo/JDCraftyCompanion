//
//  MainView.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI
import Lottie

struct MainView: View {
    
    @State private var selection = 0
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Temperature Control")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 24)
                    Spacer().frame(maxHeight: 60)
                    HStack {
                        Text("Current temperature:")
                            .font(.body)
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(viewModel.currentTemperature))ºC")
                    }
                    HStack {
                        Text("Target temperature:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(viewModel.targetTemperature))ºC")
                    }
                    HStack {
                        Text("Booster temperature:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(viewModel.boosterTargetTemperature))ºC")
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .tabItem {
                    VStack {
                        Image(systemName: "thermometer")
                        Text("Temperature")
                    }
                }
                .tag(0)
                Text("Settings Screen")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
                .tag(1)
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
                .padding(.horizontal, 24)
                .tabItem {
                    VStack {
                        Image(systemName: "info.circle")
                        Text("Information")
                    }
                }
                .tag(2)
                }
            .sheet(isPresented: $viewModel.isLoading, onDismiss: {
                // SwiftUI does not currently provide a means to prevent the user from dismissing a sheet.
                // This forces the sheet to reappear if it gets dismissed but there is still no connected device.
                if self.viewModel.state != .connected {
                    self.viewModel.isLoading = true
                }
            }) {
                return DeviceListView(viewModel: self.viewModel)
            }
        }
    }
}
