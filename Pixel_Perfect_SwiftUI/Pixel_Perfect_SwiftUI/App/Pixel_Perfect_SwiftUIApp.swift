//
//  Pixel_Perfect_SwiftUIApp.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 25.12.2021.
//

import SwiftUI

@main
struct Pixel_Perfect_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            Coordinator.shared.homeView()
        }
    }
}
