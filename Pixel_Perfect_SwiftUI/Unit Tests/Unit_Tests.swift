//
//  Unit_Tests.swift
//  Unit Tests
//
//  Created by Burhan Aras on 26.12.2021.
//

import XCTest
@testable import Pixel_Perfect_SwiftUI

class Unit_Tests: XCTestCase {

    func test_mapping_from_DTO_to_movie_should_work_fine(){
        // GIVEN: that we have a MovieDTO
        let dto = MovieDTO(id: 0, title: "title", backdrop_path: "/backdrop", poster_path: "/poster", overview: "overview", vote_average: 1.0, release_date: "2020-03-05")
        let formattedDate = "05.03.2020"
        
        // WHEN: DTO is converted to Movie object
        let sut = Movie.fromDTO(dto: dto)
        
        // THEN: Fields should be correct
        XCTAssertEqual(sut.id, dto.id)
        XCTAssertEqual(sut.title, "\(dto.title) (2020)")
        XCTAssertEqual(sut.overview, dto.overview)
        XCTAssertEqual(sut.rating, "\(dto.vote_average)")
        XCTAssertEqual(sut.releaseDate, formattedDate)
        XCTAssertEqual(sut.backdropURL.absoluteString, "https://image.tmdb.org/t/p/w500\(dto.backdrop_path ?? "")")
        XCTAssertEqual(sut.posterURL.absoluteString, "https://image.tmdb.org/t/p/w500\(dto.poster_path ?? "")")
    }
}
