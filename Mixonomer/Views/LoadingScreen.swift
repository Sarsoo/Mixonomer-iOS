//
//  LoadingScreen.swift
//  Mixonomer
//
//  Created by Andy Pack on 10/12/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import SwiftUI

struct LoadingScreen: View {
    
    var frameSize: CGFloat = 144
    @State private var isAnimating = false
    
    var body: some View {
        Image("Splash")
            // framing
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frameSize)
            // animation
            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
            .animation(
//                .easeInOut(duration: 1)
                .spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0)
                .repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
