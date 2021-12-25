//
//  HomeViewModel.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var nowPlayingMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var isPagingAvailable: Bool = true
    
    private var networkLayer: INetworkLayer = NetworkLayer()
    private var cancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage = 1
    
    
    func loadData() {
        cancellable = Publishers.Zip(
            networkLayer.getNowPlayingMovies(page: 1),
            networkLayer.getUpcomingMovies(page: 1)
        )
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        
                    case .finished:
                        break
                    case let .failure(error):
                        print("ERROR Here: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [unowned self] nowPlayingResponse, upcomingResponse in
                    print("\(nowPlayingResponse.results.count) now plaiyng")
                    print("\(upcomingResponse.results.count) upcoming")
                    self.nowPlayingMovies = nowPlayingResponse.results.map{ Movie.fromDTO(dto: $0)}
                    self.upcomingMovies = upcomingResponse.results.map{ Movie.fromDTO(dto: $0)}
                }
            )
    }
    
    func loadNextPageForUpcomingMovies() {
        currentPage += 1
        
        networkLayer.getUpcomingMovies(page: currentPage)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            } receiveValue: {[unowned self] moviesResponse in
               // print(moviesResponse.results)
                self.isPagingAvailable = (currentPage <= moviesResponse.total_pages)
                self.upcomingMovies += moviesResponse.results.map{ Movie.fromDTO(dto: $0)}
            }
            .store(in: &cancellables)
    }
}
