//
//  FiltersView.swift
//  SwiftUI-ImageFilters
//
//  Created by Himanshu Sherkar on 16/10/23.
//

import SwiftUI

struct FiltersView: View {
    
    @EnvironmentObject var filtersViewModel: FiltersViewModel
    
    @State var showEnhancements: Bool =  false
    @State var showSavedFilterList: Bool = false
    @State var showSaveAlert :Bool = false
    var body: some View {
        ScrollView {
            VStack {
                if filtersViewModel.mainView != nil {
                    if let mainView = filtersViewModel.mainView {
                        Image(uiImage: mainView)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height/2)
                        
                        HStack{
                            Button {
                                showEnhancements.toggle()
                                
                            } label: {
                                Text("Enhancements")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding()
                        

                        
                        if showEnhancements {
                            VStack(spacing: 0) {
                                Text("Contrast \(filtersViewModel.contrast)")
                                Slider(value: $filtersViewModel.contrast, in: 0.5...1.3) { value in
                                    filtersViewModel.apply { filteredImage in
                                        filtersViewModel.mainView = filteredImage
                                    }
                                }
                            }
                           
                            VStack(spacing: 0) {
                                Text("Brightness \(filtersViewModel.brightness)")
                                Slider(value: $filtersViewModel.brightness, in: -0.5...0.5) { _ in
                                    filtersViewModel.apply { filteredImage in
                                        filtersViewModel.mainView = filteredImage
                                    }
                                }
                            }
                            
                            VStack(spacing: 0) {
                                Text("Saturation \(filtersViewModel.saturation)")
                                Slider(value: $filtersViewModel.saturation, in: 0 ... 1.5) { _ in
                                    filtersViewModel.apply { filteredImage in
                                        filtersViewModel.mainView = filteredImage
                                    }
                                }
                            }
                            
                            VStack(spacing: 0) {
                                Text("UnmaskSharpness \(filtersViewModel.ciUnmasksharpVal)")
                                Slider(value: $filtersViewModel.ciUnmasksharpVal, in: 0.0...14.0) { _ in
                                    filtersViewModel.apply { filteredImage in
                                        filtersViewModel.mainView = filteredImage
                                    }
                                }
                            }
                        }
                        
                        if filtersViewModel.isEditable {
                            Slider(value: $filtersViewModel.value, in: 0 ... 1) { _ in
                                filtersViewModel.apply { filteredImage in
                                    filtersViewModel.mainView = filteredImage
                                }
                            }
                        }
                        
                        FilterView(filtersViewModel: filtersViewModel)
                        
                    }
                }
                    
                // If no image selected
                else if filtersViewModel.imageData == nil {
                    Text("Pick an image")
                }
                // Show Loading view
                else {
                    ProgressView()
                }
            }
            .onChange(of: filtersViewModel.imageData) {
                filtersViewModel.loadImage()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        filtersViewModel.saveFilter()
                        showSaveAlert.toggle()
                    } label: {
                        Text("Save")
                    }
                    

                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSavedFilterList.toggle()
                    } label: {
                        Text("Saved")
                    }

                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        filtersViewModel.imagePicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $filtersViewModel.imagePicker) {
                ImagePicker(picker: $filtersViewModel.imagePicker, imageData: $filtersViewModel.imageData)
            }
            .sheet(isPresented: $showSavedFilterList, content: {
                SavedFilter()
            })
            .alert( isPresented: $showSaveAlert) {
                Alert(title: Text("Saving Filter"), message: Text("Current filter will be saved"), dismissButton: .destructive(Text("OK")))
            }
        }
       
    }
}

#Preview {
    FiltersView()
}

struct FilterView: View {
    @ObservedObject var filtersViewModel: FiltersViewModel
   
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Button {
                    // Remove all filters
                } label: {
                    Text("None")
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(50)
                }
                
                ForEach(filtersViewModel.filters) { filter in
                    Button {
                        // Update main view with filter
                        filtersViewModel.value = 1.0
                        filtersViewModel.selectedFilter = filter
                        filtersViewModel.apply { filteredImage in
                            filtersViewModel.mainView = filteredImage
                        }
                    } label: {
                        Text(filter.filterName)
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(50)
                    }
                }
            }
            .padding()
        }
    }
}
