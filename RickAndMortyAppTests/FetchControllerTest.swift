//
//  FetchControllerTest.swift
//  RickAndMortyAppTests
//
//  Created by Alberto Aragón Peci on 8/11/24.
//

import XCTest
@testable import Rick_Morty

final class FetchControllerTest: XCTestCase {
    let fethcController = FetchController()
    
    override func setUpWithError() throws {
        // Configure URLProtocol to intercept network requests
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDownWithError() throws {
        // Remove URLProtocol settings
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }

    func testFetchCharactersSuccess() async throws {
        // Example JSON data that would represent a valid response
        let mockJSONData = """
            {
                "info": {
                    "count": 826,
                    "pages": 42,
                    "next": "https://rickandmortyapi.com/api/character?page=2",
                    "prev": null
                },
                "results": [
                    {
                        "id": 1,
                        "name": "Rick Sanchez",
                        "status": "Alive",
                        "species": "Human",
                        "gender": "Male",
                        "origin": { "name": "Earth" },
                        "location": { "name": "Citadel of Ricks" },
                        "image": "https://example.com/image.png",
                        "episode": ["https://example.com/api/episode/1"]
                    }
                ]
            }
            """.data(using: .utf8)!

        // We configure the simulated response with a 200 status and valid data
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockJSONData)
        }

        let fetchController = FetchController()
        let characterList = try await fetchController.fetchCharacters(query: "Rick", page: 1)

        XCTAssertNotNil(characterList)
        XCTAssertEqual(characterList?.info.count, 826)
        XCTAssertEqual(characterList?.info.pages, 42)
        XCTAssertEqual(characterList?.results.first?.name, "Rick Sanchez")
    }

    func testFetchCharactersBadResponse() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        let fetchController = FetchController()

        do {
            _ = try await fetchController.fetchCharacters(query: "Rick", page: 1)
            XCTFail("Expected badResponse error, but no error was thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchCharactersBadData() async {
        let invalidJSONData = "Invalid Data".data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSONData)
        }

        let fetchController = FetchController()

        do {
            _ = try await fetchController.fetchCharacters(query: "Rick", page: 1)
            XCTFail("Expected badData error, but no error was thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// Helper class to simulate URLSession responses
final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler is not set.")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
