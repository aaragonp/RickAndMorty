//
//  LoadingView.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 8/11/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                Spacer()

                HStack {
                    Spacer()
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(
                                Animation.linear(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                            ) {
                                rotation = 360
                            }
                        }
                        .shadow(color: .purple, radius: 10)
                        .shadow(color: .purple, radius: 10)
                    Spacer()

                }

                Spacer()

            }
        }
        .background(Color.black)
    }
}

#Preview {
    LoadingView()
}
