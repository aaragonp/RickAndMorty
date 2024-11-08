//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import Foundation

struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let location: CharacterLocation
    let image: String
    let episode: [String]

    func getEpisodes() -> [String] {
        return episode.compactMap { url in
            guard let lastComponent = url.split(separator: "/").last else {
                return nil
            }
            return String(lastComponent)
        }
    }
}

struct Origin: Codable, Equatable, Hashable {
    let name: String
}

struct CharacterLocation: Codable, Equatable, Hashable {
    let name: String
}
