//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let character: Character
    @State private var animateViewsIn: Bool = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    // MARK: Header
                    VStack {
                        Spacer(minLength: 100)

                        ZStack(alignment: .center) {
                            AsyncImageWithCache(url: URL(string: character.image)!)
                                .cornerRadius(6)
                                .shadow(color: .white, radius: 6)
                                .frame(width: geo.size.width * 0.7, height: geo.size.width * 0.7)
                        }

                        VStack(alignment: .trailing) {
                            if animateViewsIn {
                                Text(character.name)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.blue, radius: 8)
                                    .transition(.scale)
                            }

                            Spacer(minLength: 50)
                        }
                        .frame(width: geo.size.width, alignment: .center)
                        .animation(.easeInOut(duration: animateViewsIn ? 1 : 0), value: animateViewsIn)
                    }
                    .background(Color.white.opacity(0.2))
                    .overlay {
                        LinearGradient(stops: [
                            Gradient.Stop(color: .clear, location: 0.8),
                            Gradient.Stop(color: .black, location: 1)
                        ], startPoint: .center, endPoint: .bottom)
                    }

                    // MARK: Character status
                    VStack(alignment: .leading) {
                        if animateViewsIn {
                            HStack {
                                HStack {
                                    Image(systemName: "person")
                                        .padding(.leading)
                                    Text(character.gender)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.blue, radius: 8)
                                        .padding(.trailing, 16)
                                        .padding(.vertical, 8)
                                        .transition(.scale)
                                }
                                .background(character.gender == "Male" ? Color.blue.opacity(0.5) : Color.pink.opacity(0.5))
                                .clipShape(Capsule())

                                Text(character.status)
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.blue, radius: 8)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(character.status == "Alive" ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                                    .clipShape(Capsule())
                                    .transition(.scale)

                                Text(character.species)
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.blue, radius: 8)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.8))
                                    .clipShape(Capsule())
                                    .transition(.scale)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)

                    // MARK: Character origin and location
                    HStack() {
                        Text("Origin:")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: Color.blue, radius: 8)
                            .fontWeight(.bold)

                        Spacer()
                    }
                    .padding(.top)
                    .padding(.leading)

                    HStack() {
                        Text(character.origin.name)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: Color.blue, radius: 8)
                            .transition(.scale)
                            .fontWeight(.bold)
                            .shadow(color: Color.blue, radius: 4)

                        Spacer()
                    }
                    .padding(.top, -8)
                    .padding(.leading)

                    HStack() {
                        Text("Location:")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: Color.blue, radius: 8)
                            .fontWeight(.bold)

                        Spacer()
                    }
                    .padding(.top)
                    .padding(.leading)

                    HStack() {
                        Text(character.location.name)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .shadow(color: Color.blue, radius: 8)
                            .transition(.scale)
                            .fontWeight(.bold)
                            .shadow(color: Color.blue, radius: 4)

                        Spacer()
                    }
                    .padding(.top, -8)
                    .padding(.leading)

                    // MARK: Character episodes
                    VStack(alignment: .leading) {
                        Text("Appeared in \(character.episode.count) episodes:")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .transition(.scale)
                            .fontWeight(.bold)
                            .padding(.leading)
                            .padding(.top)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(character.getEpisodes(), id: \.self) { id in
                                    Text(id.count < 2 ? "0\(id)" : id)
                                        .font(.custom("Courier New", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue.opacity(0.8))
                                        .clipShape(Circle())
                                        .shadow(color: .white, radius: 4)
                                        .frame(height: 80)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .background(Color.black)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("")
                    }
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            animateViewsIn = true
        }
    }
}

#Preview {
    CharacterDetailView(character: Character(id: 1,
                                             name: "TestName",
                                             status: "Alive",
                                             species: "Human",
                                             gender: "Male",
                                             origin: Origin(name: "Earth"),
                                             location: CharacterLocation(name: "Solar System"),
                                             image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episode: [
                                                "https://rickandmortyapi.com/api/episode/1",
                                                "https://rickandmortyapi.com/api/episode/2",
                                                "https://rickandmortyapi.com/api/episode/3",
                                                "https://rickandmortyapi.com/api/episode/4",
                                                "https://rickandmortyapi.com/api/episode/5"
                                             ]))
}
