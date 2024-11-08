//
//  SplashView.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 8/11/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            CharacterListView()
        } else {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    Image("Rick-and-Morty-Background")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .cornerRadius(50)
                        .shadow(color: .purple, radius: 50)
                        .shadow(color: .white, radius: 10)
                    Spacer()

                }
            }
            .background(Color.black)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
