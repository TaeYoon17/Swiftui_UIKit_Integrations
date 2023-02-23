//
//  LottieView.swift
//  Lottie_Demo
//
//  Created by 김태윤 on 2023/02/23.
//

import Foundation
import SwiftUI
import Lottie
//  UIViewRepresentableContext<LottieView>
struct LottieView: UIViewRepresentable{
    typealias UIViewType = UIView
    let fileName: String
    var loopMode :LottieLoopMode = .loop
    init(fileName: String = "loading", loopMode: LottieLoopMode = .loop) {
        self.fileName = fileName
        self.loopMode = loopMode
    }
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(fileName)
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        print("iscalled")
    }
}
