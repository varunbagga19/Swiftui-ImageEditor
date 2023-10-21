//
//  SavedFilter.swift
//  SwiftUI-ImageFilters
//
//  Created by Varun Bagga on 20/10/23.
//

import SwiftUI

struct SavedFilter: View {
    
    @EnvironmentObject var filterViewmodel : FiltersViewModel
    @State var showSaveAlert : Bool = false
    @State var filterSelected : SavedFilterModel!
    var body: some View {
        List(filterViewmodel.savedFiltersList) { item in
            VStack(alignment: .leading,spacing: 3) {
                
                    Text("Contrast: \(item.contrast)")
                    Text("Brightness: \(item.brightness)")
                    Text("Saturation: \(item.saturation)")
                    Text("sharpness: \(item.sharpness)")
                    Text("Filter: \(item.filter.filterName)")
                
                }
            .onTapGesture {
                showSaveAlert.toggle()
                filterSelected = item
            }
                
            }
            .alert(isPresented: $showSaveAlert, content: {
                Alert(title: Text("Sure?"), message: Text("This will affect your image"),
                      dismissButton: .destructive(Text("Apply"),
                    action: {
                    filterViewmodel.applySavedFilter(with: filterSelected)
                }))
            })
          }
       }

#Preview {
    SavedFilter()
}
