//
//  HomeView.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.screenState {
                case .loading:
                    ProgressView()
                case .success:
                    HomeListView(viewModel: viewModel)
                case .failure:
                   ErrorView(viewModel: viewModel)
                }
            }
            .task {
                viewModel.loadData()
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
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
                    .foregroundColor(.primary)
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


struct HomeListView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        ScrollView(.vertical){
            VStack {
                // Now Playing Movies
                VStack{
                    if !viewModel.nowPlayingMovies.isEmpty {
                        TabView {
                            ForEach(viewModel.nowPlayingMovies){ movie in
                                ZStack(alignment: .bottom) {
                                    AsyncImage(
                                        url: movie.backdropURL,
                                        content: { image in
                                            GeometryReader { geo in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: geo.size.width , height: 256)
                                                
                                            }
                                        },
                                        placeholder: {
                                            GeometryReader { geo in
                                                ZStack {
                                                    ProgressView()
                                                }
                                                .frame(width: geo.size.width , height: 256)
                                                .background(Color.gray.opacity(0.3))
                                            }
                                            
                                            
                                        }
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(movie.title)
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                            .foregroundColor(Color.white)
                                        
                                        Text(movie.overview)
                                            .font(.system(size: 12, weight: .medium, design: .default))
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 40)
                                }
                                .frame(minHeight: 256)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    }
                }
                .frame(minHeight: 256)
                
                //Upcoming Movies
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
    }
}

struct ErrorView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {

        RefreshableView {
            viewModel.loadData()
        } content: {
            Spacer()
                .frame(minHeight: 200)
            VStack (spacing: 16){
                
                Image(systemName: "xmark.circle")
                Text(viewModel.errorMessage)
                Button {
                    viewModel.loadData()
                } label: {
                    Text("Try Agagin")
                        .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                }

            }
            Spacer()
            HStack{ Spacer() }
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            HomeView(viewModel: HomeViewModel(networkLayer: DummyNetworkLayer()))
            HomeView(viewModel: HomeViewModel(networkLayer: DummyNetworkLayer()))
                .preferredColorScheme(.dark)
            
            HomeView(viewModel: HomeViewModel(networkLayer: DummyFailingNetworkLayer()))
            HomeView(viewModel: HomeViewModel(networkLayer: DummyFailingNetworkLayer()))
                .preferredColorScheme(.dark)
        }

    }
}
