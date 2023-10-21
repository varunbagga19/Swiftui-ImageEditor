//
//  SwiftUI_ImageFiltersApp.swift
//  SwiftUI-ImageFilters
//
//  Created by Himanshu Sherkar on 16/10/23.
//

import SwiftUI

@main
struct SwiftUI_ImageFiltersApp: App {
    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                HomeView()
                    .navigationTitle("Filter")
                    .preferredColorScheme(.dark)
            }
        }
    }
}
