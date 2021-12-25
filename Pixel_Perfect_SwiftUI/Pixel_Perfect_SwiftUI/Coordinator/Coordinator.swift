//
//  Coordinator.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import Foundation

final class Coordinator {
    
    static let shared = Coordinator()
    
    func homeView() -> HomeView {
        return HomeView()
    }
}
