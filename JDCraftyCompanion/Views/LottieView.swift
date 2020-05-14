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
