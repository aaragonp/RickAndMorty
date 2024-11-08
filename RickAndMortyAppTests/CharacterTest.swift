//
//  CharacterTest.swift
//  RickAndMortyAppTests
//
//  Created by Alberto Aragón Peci on 8/11/24.
//

import XCTest
@testable import Rick_Morty

final class CharacterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCharacterInitialization() {
        let origin = Origin(name: "Earth")
        let location = CharacterLocation(name: "Citadel of Ricks")
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            gender: "Male",
            origin: origin,
            location: location,
            image: "https://example.com/image.png",
            episode: ["https://example.com/api/episode/1", "https://example.com/api/episode/2"]
        )

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, "Alive")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.gender, "Male")
        XCTAssertEqual(character.origin.name, "Earth")
        XCTAssertEqual(character.location.name, "Citadel of Ricks")
        XCTAssertEqual(character.image, "https://example.com/image.png")
        XCTAssertEqual(character.episode.count, 2)
    }

    func testGetEpisodes() {
        let character = Character(
            id: 1,
            name: "Morty Smith",
            status: "Alive",
            species: "Human",
            gender: "Male",
            origin: Origin(name: "Earth"),
            location: CharacterLocation(name: "Earth"),
            image: "https://example.com/image.png",
            episode: ["https://example.com/api/episode/1", "https://example.com/api/episode/42"]
        )

        let episodeIds = character.getEpisodes()
        XCTAssertEqual(episodeIds, ["1", "42"], "The getEpisodes method should correctly extract episode IDs.")
    }
}
