//
//  DetailView.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 26.12.2021.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            
            topBar
            
            AsyncImage(
                url: movie.backdropURL,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            
            
            HStack(spacing: 8){
                Image("imdb")
                    .resizable()
                    .frame(width: 49, height: 24, alignment: .center)
                
                HStack(spacing: 0) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                        .padding(.trailing, 4)
                    Text(movie.rating)
                        .font(.system(size: 13, weight: .medium, design: .default))
                    Text("/10")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                }
                
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 4, height: 4)
                
                Text(movie.releaseDate)
                    .font(.system(size: 13, weight: .medium, design: .default))
            }
            .padding(.horizontal, 16)
            
            Text(movie.title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .padding(16)
            
            
            Text(movie.overview)
                .font(.system(size: 15, weight: .regular, design: .default))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    var topBar: some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .padding(12)
            }
            
            Spacer()
            
            Text(movie.title)
                .font(.system(size: 20, weight: .bold, design: .default))
            
            Spacer()
            
            Button {
               
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .padding(12)
            }
            .hidden()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(movie: Movie(
            id: 0,
            title: "Bloodshot (2020)",
            backdropURL: URL(string: "https://image.tmdb.org/t/p/w500/sQkRiQo3nLrQYMXZodDjNUJKHZV.jpg")!, posterURL: URL(string: "https://image.tmdb.org/t/p/w500/c01Y4suApJ1Wic2xLmaq1QYcfoZ.jpg")!, releaseDate: "15.06.2021", rating: "7.8", overview: "After he and his wife are murdered, marine Ray Garrison is resurrected by a team of scientists. Enhanced with nanotechnology, he becomes a superhuman, biotech killing machine—'Bloodshot'. As Ray first trains with fellow super-soldiers, he cannot recall anything from his former life. But when his memories flood back and he remembers the man that killed both him and his wife, he breaks out of the facility to get revenge, only to discover that there's more to the conspiracy than he thought."))
    }
}
