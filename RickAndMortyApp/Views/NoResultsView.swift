//
//  NoResultsView.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 7/11/24.
//

import SwiftUI

struct NoResultsView: View {
    let retryAction: () -> Void
    @State private var scalePlayButton = false

    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack {
                    Text("No results found!")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .shadow(color: Color.red, radius: 8)

                    Image("rick-and-morty-error")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.white, radius: 10)
                        .padding()

                    VStack {
                        Button(action: retryAction) {
                            Image(systemName: "arrow.trianglehead.2.clockwise")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .tint(Color.white)
                                .padding(.leading)

                            Text("Retry")
                                .font(.title3)
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .fontWeight(.bold)
                        }
                        .background(Color.green.opacity(0.5))
                        .cornerRadius(10)
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                scalePlayButton.toggle()
                            }
                        }
                        .transition(.offset(y: geo.size.height/3))
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value:  true)
                }
            }
            .colorScheme(.dark)
        }
    }
}

#Preview {
    NoResultsView(retryAction: {
    })
}
