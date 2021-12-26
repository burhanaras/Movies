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
        NavigationView {
            VStack {
                ScrollView(.vertical){
                    
                    if !viewModel.nowPlayingMovies.isEmpty {
                        TabView {
                            ForEach(viewModel.nowPlayingMovies){ movie in
                                ZStack {
                                        AsyncImage(url: movie.backdropURL)
                                          .frame(minHeight: 256)
                                    Image("spider")
                                        .resizable()
                                        .frame(minHeight: 256)
                                    VStack(spacing: 8) {
                                        Text(movie.title)
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                            .foregroundColor(Color.white)
                                        
                                        Text(movie.overview)
                                            .font(.system(size: 12, weight: .medium, design: .default))
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(16)
                                }
                                .frame(height: 256)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    }
                    
                    LazyVStack(alignment: .leading){
                        ForEach(viewModel.upcomingMovies){ movie in
                            VStack {
                                NavigationLink {
                                    DetailView(movie: movie)
                                } label: {
                                    MovieView(movie: movie)
                                }
                                Divider()
                                    .padding(.horizontal, 16)
                            }
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
        .edgesIgnoringSafeArea(.top)
        }
    }
}

struct MovieView: View {
    let movie: Movie
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(
                url: movie.posterURL,
                content: { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 104, height: 104)
                        .cornerRadius(12)
                        .clipped()
                },
                placeholder: {
                    ProgressView()
                }
            )
            
            VStack(alignment: .leading) {
                Text(movie.title).bold()
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 8)
                Text(movie.overview)
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 16)
                HStack {
                    Spacer()
                    Text(movie.releaseDate)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                }
            }
            HStack{
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
            }
            .frame(width: 28)
        }
        .padding(16)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
