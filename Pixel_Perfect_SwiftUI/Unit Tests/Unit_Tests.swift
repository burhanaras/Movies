//
//  Unit_Tests.swift
//  Unit Tests
//
//  Created by Burhan Aras on 26.12.2021.
//

import XCTest
import Combine
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
    
    func test_HomeViewModel_should_show_data_correctly_when_network_returns_successful_data(){
        // GIVEN: that we have a network layer that returns some movies
        let moviesResponse = MoviesResponse(page: 1, total_pages: 10, results: dummydata(count: 20))
        let networkLayer: INetworkLayer = TestNetworkLayer(response: moviesResponse)
        let sut = HomeViewModel(networkLayer: networkLayer)
        
        // WHEN: loadData() of HomeviewModel is called
        sut.loadData()
        
        // THEN: HomeViewModel's data should be same as received data
        XCTAssertEqual(20, sut.nowPlayingMovies.count)
        XCTAssertEqual(20, sut.upcomingMovies.count)
    }
    
    func test_HomeviewModel_should_show_error_message_when_network_fails(){
        // GIVEN: that we have a failing network layer
        let networkLayer: INetworkLayer = TestFailingNetworkLayer(response: RequestError.apiError)
        let sut = HomeViewModel(networkLayer: networkLayer)
        
        // WHEN: loadData() of HomeviewModel is called
        sut.loadData()
        
        // THEN: HomeViewModel's error message must be correct and data should be empty
        XCTAssertEqual(0, sut.nowPlayingMovies.count)
        XCTAssertEqual(0, sut.upcomingMovies.count)
        XCTAssertEqual(RequestError.apiError.localizedDescription, sut.errorMessage)
    }
}


// MARK: - Test network layer that returns successful data or fails
class TestNetworkLayer: INetworkLayer {
    private let response: MoviesResponse
    
    init(response: MoviesResponse){
        self.response = response
    }
    
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.success(response))
            .eraseToAnyPublisher()
    }
    
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.success(response))
            .eraseToAnyPublisher()
    }
    
}

class TestFailingNetworkLayer: INetworkLayer {
    private let response: RequestError
    
    init(response: RequestError){
        self.response = response
    }
    
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.failure(response))
            .eraseToAnyPublisher()
    }
    
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.failure(response))
            .eraseToAnyPublisher()
    }
    
}


// MARK: - Dummy data

func dummydata(count: Int) -> [MovieDTO] {
    var data = [MovieDTO]()
    for index in 0..<count {
        let dto = MovieDTO(id: index, title: "title", backdrop_path: "/backdrop", poster_path: "/poster", overview: "overview", vote_average: 1.0, release_date: "2020-03-05")
        data.append(dto)
    }
    return data
}
