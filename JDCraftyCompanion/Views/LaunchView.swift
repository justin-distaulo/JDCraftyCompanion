//
//  LaunchView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-29.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

//import SwiftUI
//import Combine
//
//struct LaunchView: View {
//
//    @ObservedObject var viewModel = MainViewModel()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Text("JD's Crafty Companion")
//                    .foregroundColor(Color.jdText)
//                    .font(.largeTitle)
//                    .fontWeight(.black)
//                Spacer()
//                    .frame(maxHeight: 32)
//                LottieView(name: "hamster")
//                    .frame(width: 100, height: 100)
//            }
//            if viewModel.isLoading {
//                BlurView(style: .regular)
//                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.25)))
//                DeviceListView(viewModel: viewModel)
//                    .transition(AnyTransition.slide.animation(.easeOut(duration:0.25)))
//            }
//        }
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//        .background(Color.jdBackground)
//        .edgesIgnoringSafeArea(.vertical)
//        .onAppear {
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
//                self.viewModel.startScanning()
//            }
//        }
//    }
//}

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
                Spacer()
                    .frame(maxHeight: 32)
                LottieView(name: "hamster")
                    .frame(width: 100, height: 100)
            }
            if viewModel.isLoading {
                BlurView(style: .regular)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.25)))
                DeviceListView(viewModel: viewModel)
                    .transition(AnyTransition.move(edge: .bottom).animation(.easeOut(duration:0.25)))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.jdBackground)
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            //TODO: WTF, bro?!?
            withAnimation {
                self.viewModel.startScanning()
            }
        }
    }
}


