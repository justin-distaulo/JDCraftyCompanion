//
//  DeviceListView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-22.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI

struct DeviceListView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
//        GeometryReader { geometry in
            VStack(spacing: 16) {
                Text(self.viewModel.loadingText)
                Text("Found Devices:")
                ForEach(self.viewModel.devices, id: \.identifier) { device in
                    Text(device.name).onTapGesture {
                        if self.viewModel.state == .scanning {
                            self.viewModel.connect(toDevice: device)
                        }
                    }
                }
            }
//            .frame(width: geometry.size.width)
//            .padding(.top, 16)
//            .padding(.bottom, geometry.safeAreaInsets.bottom)
            .background(Color.white)
        }
//    }
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
        
    }
}
