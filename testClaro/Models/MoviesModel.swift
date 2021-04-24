//
//  MoviesModel.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import Foundation

struct MoviesModel: Codable {
    let results: [Results]
}

struct Results: Codable {
    let poster_path: String?
    let title: String?
    let release_date: String?
}
