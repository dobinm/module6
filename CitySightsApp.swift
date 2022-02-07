//
//  CitySightsApp.swift
//  City Sights App
//
//  Created by Michael Dobin on 1/27/22.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
