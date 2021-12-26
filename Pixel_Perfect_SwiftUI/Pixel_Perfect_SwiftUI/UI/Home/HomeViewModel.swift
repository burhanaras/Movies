//
//  HomeViewModel.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation
import Combine

enum ScreenState {
    case success, loading, failure
}

class HomeViewModel: ObservableObject {
    @Published var nowPlayingMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var isPagingAvailable: Bool = true
    @Published var screenState: ScreenState = .loading
    @Published var errorMessage: String = ""
    
    private var networkLayer: INetworkLayer
    private var cancellable: AnyCancellable? = nil
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage = 1
    
    init(networkLayer: INetworkLayer){
        self.networkLayer = networkLayer
    }
    
    func loadData() {
        self.screenState = .loading
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
                        self.errorMessage = error.localizedDescription
                        self.screenState = .failure
                    }
                },
                receiveValue: { [unowned self] nowPlayingResponse, upcomingResponse in
                    print("\(nowPlayingResponse.results.count) now plaiyng")
                    print("\(upcomingResponse.results.count) upcoming")
                    self.nowPlayingMovies = nowPlayingResponse.results.map{ Movie.fromDTO(dto: $0)}
                    self.upcomingMovies = upcomingResponse.results.map{ Movie.fromDTO(dto: $0)}
                    self.screenState = .success
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
