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
                TemperatureView(viewModel: self.viewModel)
                    .modifier(TabViewModifier())
                    .tag(0)
                SettingsView(viewModel: self.viewModel)
                    .modifier(TabViewModifier())
                    .tag(1)
                DeviceInfoView(viewModel: self.viewModel)
                    .modifier(TabViewModifier())
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

struct TabViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        return content
            .padding(.horizontal, 24)
            .tabItem {
                VStack {
                    Image(systemName: "thermometer")
                    Text("Temperature")
                }
        }
    }
}

