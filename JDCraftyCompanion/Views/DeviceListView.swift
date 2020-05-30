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
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack(spacing: 8) {
                    Spacer(minLength: 2)
                    Text("Found Devices:")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.jdText)
                    ForEach(self.viewModel.devices, id: \.identifier) { device in
                        HStack {
                            Text(device.name)
                                .font(.body)
                                .foregroundColor(Color.jdText)
                            Spacer()
                            Button("Connect") {
                                if self.viewModel.state == .scanning {
                                    self.viewModel.connect(toDevice: device)
                                }
                            }
                            .font(.body)
                            .foregroundColor(Color.jdText)
                        }
                        .padding(.horizontal, 16)
                    }
                    Spacer(minLength: 4)
                }
                .frame(width: geometry.size.width - 16, height: geometry.size.height/8, alignment: .bottom)
                .background(Color.jdBackground)
                .cornerRadius(6)
                Spacer()
                    .frame(width: geometry.size.width, height: 8, alignment: .bottom)
            }
        }
    }
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
