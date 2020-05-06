//
//  ContentView.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 2
 
    var body: some View {
        TabView(selection: $selection) {
            Text("Temperature Screen")
                .font(.title)
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
                    Text("Device Info").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                }
                .padding(.top, 24)
                Spacer().frame(maxHeight: 60)
                HStack {
                    Text("Serial number:")
                        .font(.body)
                        .fontWeight(.bold)
                    Spacer()
                    Text(DeviceManager.serial)
                }
                HStack {
                    Text("Model:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(DeviceManager.model)
                }
                HStack {
                    Text("Version:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(DeviceManager.version)
                }
                HStack {
                    Text("Hours:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(DeviceManager.hours))
                }
                Spacer()
            }.padding(.horizontal, 24)
            .tabItem {
                VStack {
                    Image(systemName: "info.circle")
                    Text("Information")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
    }
}
