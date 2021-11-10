//
//  LaunchView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-29.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct LaunchView: View {

    @ObservedObject var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            VStack {
                Text("JD's Crafty Companion")
                    .foregroundColor(Color.jdText)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                Spacer()
                    .frame(maxHeight: 32)
                LottieView(name: "hamster")
                    .frame(width: 100, height: 100)
            }
            if viewModel.state == .scanning {
                BlurView(style: .systemUltraThinMaterialDark)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.25)))
                DeviceListView(viewModel: viewModel)
                    .transition(AnyTransition.move(edge: .bottom).animation(.easeOut(duration:0.35)))
            }
            if viewModel.state == .connected && viewModel.isLoading == false {
                MainView(viewModel: viewModel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.jdBackground)
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
                // TODO: Figure out why this is necessary
                withAnimation {
                    self.viewModel.startScanning()
                }
            }
        }
    }
}
