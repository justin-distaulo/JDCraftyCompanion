//
//  ContentView.swift
//  JD's Crafty Companion
//
//  Created by Justin DiStaulo on 2020-04-30.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI
import Lottie

struct ContentView: View {
    
    @State private var selection = 0
    @ObservedObject private var device = DeviceViewModel()
    
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
                        Text("\(String(self.device.currentTemperature))ºC")
                    }
                    HStack {
                        Text("Target temperature:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(self.device.targetTemperature))ºC")
                    }
                    HStack {
                        Text("Booster temperature:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(self.device.targetTemperature + self.device.boosterTemperature))ºC")
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
                        Text(self.device.serialNumber)
                    }
                    HStack {
                        Text("Model:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(self.device.model)
                    }
                    HStack {
                        Text("Firmware version:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(self.device.firmware)
                    }
                    HStack {
                        Text("Power on time:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(self.device.powerOnTime)) hours")
                    }
                    HStack {
                        Text("Battery:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(self.device.battery))%")
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
            .opacity(self.device.isLoading ? 0 : 1)
            VStack {
                LottieView(name: "hamster")
                    .frame(width: 100, height: 100)
                Spacer()
                    .frame(maxHeight: 16)
                Text(self.device.loadingText)
            }
            .opacity(self.device.isLoading ? 1 : 0)
        }
    }
}

struct LottieView: UIViewRepresentable {
    
    class Coordinator: NSObject {
        
        var parent: LottieView
    
        init(_ animationView: LottieView) {
            
            self.parent = animationView
            super.init()
        }
    }
    
    var name: String!
    var animationView = AnimationView()

    func makeCoordinator() -> Coordinator {
        
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView()

        self.animationView.animation = Animation.named(self.name)
        self.animationView.loopMode = .loop
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.animationView)

        NSLayoutConstraint.activate([
            self.animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
        self.animationView.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
