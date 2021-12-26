//
//  DummyNetworkLayer.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 26.12.2021.
//

import Foundation
import Combine

class DummyNetworkLayer: INetworkLayer {
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.success(MoviesResponse(page: 1, total_pages: 10, results: dummyData(count: 10))))
            .eraseToAnyPublisher()
    }
    
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.success(MoviesResponse(page: 1, total_pages: 50, results: dummyData(count: 100))))
            .eraseToAnyPublisher()
    }
}

class DummyFailingNetworkLayer: INetworkLayer {
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.failure(.apiError))
            .eraseToAnyPublisher()
    }
    
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        return Result<MoviesResponse, RequestError>
            .Publisher(.failure(.apiError))
            .eraseToAnyPublisher()
    }
}

func dummyData(count: Int) -> [MovieDTO] {
    var data = [MovieDTO]()
    for index in 0..<count {
        let movie = MovieDTO(id: index, title: "Bloodshot", backdrop_path: "/ocUrMYbdjknu2TwzMHKT9PBBQRw.jpg", poster_path: "/8WUVHemHFH2ZIP6NWkwlHWsyrEL.jpg", overview: "After he and his wife are murdered, marine Ray Garrison is resurrected by a team of scientists. Enhanced with nanotechnology, he becomes a superhuman, biotech killing machine—'Bloodshot'. As Ray first trains with fellow super-soldiers, he cannot recall anything from his former life. But when his memories flood back and he remembers the man that killed both him and his wife, he breaks out of the facility to get revenge, only to discover that there's more to the conspiracy than he thought.", vote_average: 7.1, release_date: "2020-03-05")
        data.append(movie)
    }
    return data
}
