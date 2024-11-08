//
//  ListInfo.swift
//  RickAndMortyApp
//
//  Created by Alberto Aragón Peci on 6/11/24.
//

import Foundation

struct ListInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
