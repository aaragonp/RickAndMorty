//
//  FetchController.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import Foundation

enum Status {
    case notStarted
    case fetching
    case success
    case fails
}

enum NetworkError: Error {
    case badURL, badResponse, badData
}

struct FetchController {
    private let baseURL = "https://rickandmortyapi.com/api/character"

    func fetchCharacters(query: String, page: Int) async throws -> CharacterList? {
        var urlString = "\(baseURL)?page=\(page)"
        if !query.isEmpty {
            urlString += "&name=\(query)"
        }
        let url = URL(string: urlString)!
        let fetchComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)

        guard let fethcURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: fethcURL)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        do {
            let list = try JSONDecoder().decode(CharacterList.self, from: data)
            if list.results.isEmpty {
                throw NetworkError.badData
            }
            return list
        } catch {
            throw NetworkError.badData
        }
    }
}
