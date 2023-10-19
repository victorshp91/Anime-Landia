//
//  CustomLoadingView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/19/23.
//


import SwiftUI
struct CustomLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .onAppear() {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
        
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView: View {
    var body: some View {
        CustomLoadingView()
    }
}

