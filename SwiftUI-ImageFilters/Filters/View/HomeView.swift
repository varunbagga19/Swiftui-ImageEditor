//
//  HomeView.swift
//  SwiftUI-ImageFilters
//
//  Created by Varun Bagga on 20/10/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        let filtersViewmodel = FiltersViewModel()
       FiltersView()
            .environmentObject(filtersViewmodel)
    }
}

#Preview {
    HomeView()
}
