//
//  NetworkLayer.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation
import Combine

protocol INetworkLayer {
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError>
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError>
}

class NetworkLayer: INetworkLayer {
    private let decoder = JSONDecoder()
    
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        guard let url = getComponentsForNowPlayingMoviesRequest(page: page).url else {
            return Fail<MoviesResponse, RequestError>(error: .invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<MoviesResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    func getUpcomingMovies(page: Int) -> AnyPublisher<MoviesResponse, RequestError> {
        guard let url = getComponentsForUpcomingMoviesRequest(page: page).url else {
            return Fail<MoviesResponse, RequestError>(error: .invalidEndpoint)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<MoviesResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
    }
    
    private func fetch<NetworkModel: Codable>(url: URL?) -> AnyPublisher<NetworkModel, RequestError>{
        guard let url = url else{
            return Result<NetworkModel, RequestError>
                .Publisher(.failure(.invalidEndpoint))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        print(request)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map{
                print(String(data: $0.data, encoding: .utf8) as Any)
                return $0.data
            }
            .decode(type: NetworkModel.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError{_ in return .apiError}
            .eraseToAnyPublisher()
        
    }
    
}
