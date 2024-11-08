//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject private var characterListVm = CharacterListViewModel(controller: FetchController())
    @State var searchText = ""

    var body: some View {
        switch characterListVm.status {
        case .success:
            NavigationStack {
                List(characterListVm.allCharacters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        HStack {
                            // Image
                            AsyncImageWithCache(url: URL(string: character.image)!)
                                .frame(width: 100, height: 100)
                                .cornerRadius(6)
                                .shadow(color: .white, radius: 6)

                            VStack(alignment: .leading) {
                                // Name
                                Text(character.name)
                                    .fontWeight(.bold)
                                    .accessibilityIdentifier("CharacterName_\(character.id)")

                                // Origin
                                Text(character.origin.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 2)
                                    .accessibilityIdentifier("CharacterOrigin_\(character.id)")

                                // Gender
                                Text(character.gender.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.5))
                                    .clipShape(.capsule)
                                    .accessibilityIdentifier("CharacterGender_\(character.id)")
                            }
                            .padding()
                        }
                        .onAppear {
                            if character == characterListVm.allCharacters.last {
                                Task {
                                    do {
                                        try await characterListVm.getCharacters(query: searchText)
                                    } catch {
                                        print("Error al obtener personajes: \(error)")
                                    }
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .accessibilityIdentifier("CharacterRow_\(character.id)")
                }
                .navigationTitle("Rick & Morty")
                .navigationDestination(for: Character.self, destination: { character in
                    CharacterDetailView(character: character)
                })
                .searchable(text: $searchText)
                .accessibilityIdentifier("CharacterSearchBar")
                .autocorrectionDisabled()
                .onChange(of: searchText) { query in
                    Task {
                        do {
                            try await characterListVm.getCharacters(query: query)
                        } catch {
                            print("Error al obtener personajes: \(error)")
                        }
                    }
                }
            }
            .colorScheme(.dark)
            .accessibilityIdentifier("CharacterNavigationStack")
        case .fails:
            NoResultsView {
                Task {
                    do {
                        searchText = ""
                        try await characterListVm.getCharacters(query: searchText)
                    } catch {
                        print("Error al obtener personajes: \(error)")
                    }
                }
            }
            .accessibilityIdentifier("NoResultsView")
        default:
            LoadingView()
                .accessibilityIdentifier("CharacterLoadingIndicator")
        }
    }
}

#Preview {
    CharacterListView()
}
