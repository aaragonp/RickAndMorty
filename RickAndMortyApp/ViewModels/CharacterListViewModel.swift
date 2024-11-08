//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var allCharacters: [Character] = []
    @Published private(set) var status = Status.notStarted

    var nextPage: Int = 1
    var lastPage: Int = 1
    var query: String = ""

    private let controller: FetchController

    init(controller: FetchController, isTestMode: Bool = false) {
        self.controller = controller

        if isTestMode {
            // Simulated data for testing
            self.allCharacters = [
                Character(id: 1,
                          name: "Rick Sanchez",
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
                          ]),
                Character(id: 2,
                          name: "Morty Smith",
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
                          ])
            ]
            self.status = .success
        } else {
            // Loading real data
            Task {
                try await getCharacters()
            }
        }
    }

    @MainActor
    func getCharacters(query: String = "") async throws {
        if query != self.query {
            self.query = query
            nextPage = 1
            lastPage = 1
            allCharacters.removeAll()
        }

        do {
            guard let characterList = try await FetchController().fetchCharacters(query: query, page: nextPage) else {
                status = .fails
                return
            }

            lastPage = characterList.info.pages
            if nextPage < lastPage {
                nextPage += 1
            }
            allCharacters = allCharacters + characterList.results
            status = .success
        } catch {
            status = .fails
        }
    }
}
