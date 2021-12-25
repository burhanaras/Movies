//
//  HomeView.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack {

            ScrollView(.vertical){
                LazyVStack(alignment: .leading){
                    Text("Now Playing").bold().padding()
                    ForEach(viewModel.nowPlayingMovies){ movie in
                        Text(movie.title)
                    }
                    
                    Text("Upcoming").bold().padding()
                    ForEach(viewModel.upcomingMovies){ movie in
                        Text(movie.title)
                    }
                    
                    if viewModel.isPagingAvailable {
                        ProgressView()
                            .onAppear {
                                viewModel.loadNextPageForUpcomingMovies()
                            }
                    }
                }
            }
        }
        .task {
            viewModel.loadData()
        }
        .refreshable {
            viewModel.loadData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
