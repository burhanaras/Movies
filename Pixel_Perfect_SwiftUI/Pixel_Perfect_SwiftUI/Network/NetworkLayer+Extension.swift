//
//  NetworkLayer+Extension.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation

extension NetworkLayer {
    struct TMDBAPI{
        static let schema = "https"
        static let host = "api.themoviedb.org"
        
        fileprivate static var apiKey: String {
          get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "API-Keys-Info", ofType: "plist") else {
              fatalError("Couldn't find file 'API-Keys-Info.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
              fatalError("Couldn't find key 'API_KEY' in 'API-Keys.plist'.")
            }
            return value
          }
        }
        
    }
    
    func getComponentsForNowPlayingMoviesRequest(page: Int) -> URLComponents{
        var components = URLComponents()
        components.scheme = TMDBAPI.schema
        components.host = TMDBAPI.host
        components.path = "/3/movie/now_playing"
        
        components.queryItems = [
            .init(name: "api_key", value: TMDBAPI.apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
        return components
    }
    
    func getComponentsForUpcomingMoviesRequest(page: Int) -> URLComponents{
        var components = URLComponents()
        components.scheme = TMDBAPI.schema
        components.host = TMDBAPI.host
        components.path = "/3/movie/upcoming"
        
        components.queryItems = [
            .init(name: "api_key", value: TMDBAPI.apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
        return components
    }
}
