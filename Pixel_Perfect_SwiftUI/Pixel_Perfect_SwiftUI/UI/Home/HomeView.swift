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
            Text("Now Playing")
            List {
                ForEach(viewModel.nowPlayingMovies){ movie in
                    Text(movie.title)
                }
            }
            
            Text("Upcoming")
            List {
                ForEach(viewModel.upcomingMovies){ movie in
                    Text(movie.title)
                }
            }
        }
        .task {
            viewModel.loadData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
