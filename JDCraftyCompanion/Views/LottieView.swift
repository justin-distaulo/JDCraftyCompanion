//
//  LottieView.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-05-13.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    class Coordinator: NSObject {
        
        var parent: LottieView
    
        init(_ animationView: LottieView) {
            parent = animationView
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

        animationView.animation = Animation.named(name)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
    }
}
