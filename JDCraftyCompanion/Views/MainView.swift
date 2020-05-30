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
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                DeviceStatusView(viewModel: self.viewModel)
                    .padding(.horizontal, 8)
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                    .padding(.bottom, 4)
                    .frame(width: geometry.size.width)
                    .background(Color.jdHighlight)
                TabView(selection: self.$selection) {
                    TemperatureView(viewModel: self.viewModel)
                        .modifier(TabViewModifier(icon: "thermometer", label: "Temperature"))
                        .tag(0)
                    SettingsView(viewModel: self.viewModel)
                        .modifier(TabViewModifier(icon: "gear", label: "Settings"))
                        .tag(1)
                    DeviceInfoView(viewModel: self.viewModel)
                        .modifier(TabViewModifier(icon: "info.circle", label: "Information"))
                        .tag(2)
                }
                .background(Color.jdBackground)
                .accentColor(Color.jdText)
            }
        }
    }
}

struct TabViewModifier: ViewModifier {
    
    var icon: String
    var label: String
    
    func body(content: Content) -> some View {
        return content
            .background(Color.clear)
            .padding(.horizontal, 24)
            .tabItem {
                VStack {
                    Image(systemName: icon)
                    Text(label)
                }
        }
    }
}

