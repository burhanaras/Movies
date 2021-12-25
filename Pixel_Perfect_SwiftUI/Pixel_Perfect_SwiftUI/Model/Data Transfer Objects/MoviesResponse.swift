//
//  MoviesResponse.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let release_date: String?
    
}

struct MoviesResponse: Codable {
    let page: Int
    let total_pages: Int
    let results: [MovieDTO]
}
