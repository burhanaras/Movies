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
    private var networkLayer: INetworkLayer = NetworkLayer()
    private var cancellable: AnyCancellable?
    
    
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
}
