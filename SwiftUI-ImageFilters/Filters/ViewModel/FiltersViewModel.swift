//
//  FiltersViewModel.swift
//  SwiftUI-ImageFilters
//
//  Created by Himanshu Sherkar on 16/10/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import CoreImage.CIColor

class FiltersViewModel: ObservableObject {
    
    @Published var imagePicker: Bool = false
    @Published var imageData: Data?
    
    @Published var mainView: UIImage?
    @Published var selectedFilter: Filter?
    @Published var isEditable: Bool = false
    @Published var value: CGFloat = 1.0
    
    @Published var savedFiltersList : [SavedFilterModel] = []
    
    
    @Published var contrast: CGFloat = 1.0
    @Published var brightness: CGFloat = 0.0
    @Published var saturation: CGFloat = 1.0
    @Published var ciUnmasksharpVal : CGFloat = 1.0
    
    
    let context = CIContext()
    
    let filters: [Filter] = builtInFilters
    
    func loadImage() {
        
        guard let imageData = self.imageData else { return }
        
        let uiImage = UIImage(data: imageData)
        self.mainView = uiImage
    }
    //MARK: - Saving Features method
    
    func applySavedFilter(with savedFilter:SavedFilterModel) {
        
        self.contrast = savedFilter.contrast
        self.brightness = savedFilter.brightness
        self.saturation = savedFilter.saturation
        self.ciUnmasksharpVal = savedFilter.sharpness
        self.selectedFilter = savedFilter.filter
        
        apply { filteredImage in
            if let filteredImage = filteredImage {
                // Update UI with the filtered image
                self.mainView = filteredImage
            }
        }
        
    }

    
    
    func saveFilter() {
        
        let savedValues = SavedFilterModel(contrast: (contrast), sharpness: (ciUnmasksharpVal), brightness: brightness, saturation: (saturation), filter: selectedFilter ?? Filter(filterName: "", filterType: CIFilter()))

        print(savedValues)
        
        savedFiltersList.append(savedValues)
        
    }
    
    
    //MARK: - Normal Featuers method
    
    
    func apply(completion: @escaping (UIImage?) -> Void) {
        guard let imageData = self.imageData else {
            completion(nil)
            return
        }
        
        guard let ciImage = CIImage(data: imageData) else {
            completion(nil)
            return
        }
        
        // Apply color correction asynchronously
        applyColorCorrection(on: ciImage) { correctedImage in
            guard let correctedImage = correctedImage else {
                completion(nil)
                return
            }
            
            // Apply selected filter asynchronously
            self.applyFilter(on: correctedImage) { filteredImage in
                guard let filteredImage = filteredImage else {
                    completion(nil)
                    return
                }
                
                // Create CGImage from filtered CIImage
                guard let cgImage = self.context.createCGImage(filteredImage, from: filteredImage.extent) else {
                    completion(nil)
                    return
                }
                
                // Create UIImage from CGImage
                let finalImage = UIImage(cgImage: cgImage, scale: self.mainView?.scale ?? 1.0, orientation: self.mainView?.imageOrientation ?? .up)
                
                // Call the completion handler with the final image
                completion(finalImage)
            }
        }
    }

    
    
    
    
    func applyColorCorrection(on ciImage: CIImage, completion: @escaping (CIImage?) -> Void) {

        print("inside color correction")
        DispatchQueue.global(qos: .userInteractive).async {
            // loading image into filter
//            guard let imageData = self.imageData else { return }
//            
//            guard let ciImage = CIImage(data: imageData) else { return }
//            
//            guard let mainView = self.mainView else { return }
            
            
            let filter = CIFilter.colorControls()
            
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            // set Contrast
            if filter.inputKeys.contains(kCIInputContrastKey) {
                filter.setValue(self.contrast, forKey: kCIInputContrastKey)
            }
            
            // set Brightness
            if filter.inputKeys.contains(kCIInputBrightnessKey) {
                filter.setValue(self.brightness, forKey: kCIInputBrightnessKey)
            }
            
            // set Saturation
            if filter.inputKeys.contains(kCIInputSaturationKey) {
                filter.setValue(self.saturation * 2, forKey: kCIInputSaturationKey)
            }
            //sharpness
            let unMaskSharpFilter = CIFilter.unsharpMask()
                
                unMaskSharpFilter.setValue(filter.outputImage, forKey: kCIInputImageKey)
                unMaskSharpFilter.setValue(self.ciUnmasksharpVal, forKey: "inputIntensity")
                unMaskSharpFilter.setValue(self.ciUnmasksharpVal/2, forKey: "inputRadius")
            
            
            // retreive filtered image
            guard let newImage = unMaskSharpFilter.outputImage else { return }
            
            DispatchQueue.main.async {
                       completion(newImage)
            }
          
        }
    }
    
  
    func applyFilter(on ciImage: CIImage, completion: @escaping (CIImage?) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            // loading image into filter
//            guard let imageData = self.imageData else { return }
//            
//            guard let ciImage = CIImage(data: imageData) else { return }
            guard let filter = self.selectedFilter else { return }
            
//            guard let mainView = self.mainView else { return }
            
            print("inside filter")
            filter.filterType.setValue(ciImage, forKey: kCIInputImageKey)

            DispatchQueue.main.async {
                self.isEditable = filter.filterType.inputKeys.count - 1 > 1
                print(filter.filterType.inputKeys)
            }


            if filter.filterName == "Sepia" {
                filter.filterType.setValue(self.value, forKey: kCIInputIntensityKey)
            }
            
            if filter.filterName == "Gaussian Blur" {
                filter.filterType.setValue(self.value * 20, forKey: kCIInputRadiusKey)
            }
            
            if filter.filterName == "Bloom" {
                filter.filterType.setValue(self.value * 5 , forKey: kCIInputIntensityKey)
                filter.filterType.setValue(self.value * 2, forKey: kCIInputRadiusKey)
            }
        
            if filter.filterName == "Color Monochrome" {
                filter.filterType.setValue(self.value,forKey: kCIInputIntensityKey)
            }
            
            if filter.filterName == "Crystalize"{
                filter.filterType.setValue(self.value * 12, forKey: kCIInputRadiusKey)
            }
            
            if filter.filterName == "Hue" {
                filter.filterType.setValue(self.value, forKey: kCIInputAngleKey)
            }
            
            if filter.filterName == "Pixelate"{
                filter.filterType.setValue(self.value * 10, forKey: kCIInputScaleKey)
            }
            
            if filter.filterName == "Dots"{
                filter.filterType.setValue(self.value, forKey: kCIInputSharpnessKey)
                filter.filterType.setValue(self.value * 10,forKey: kCIInputWidthKey)
            }
            
            if filter.filterName == "Color Posteriz" {
                filter.filterType.setValue(self.value * 50, forKey: "inputLevels")
            }
            
            if filter.filterName == "Contrast" {
                filter.filterType.setValue(self.value * 60, forKey: "inputExtrapolate")
            }
            
            if filter.filterName == "Vignette" {
                filter.filterType.setValue(self.value * 30, forKey: kCIInputIntensityKey)
            }
            
            if filter.filterName == "Color Cross" {
                let colorCoefficients = CIVector(x: CGFloat(self.value), y: CGFloat(self.value), z: CGFloat(self.value), w: 1.0)
                filter.filterType.setValue(colorCoefficients , forKey: "inputRedCoefficients")
                filter.filterType.setValue(colorCoefficients  , forKey: "inputGreenCoefficients")
                filter.filterType.setValue(colorCoefficients , forKey: "inputBlueCoefficients")
            }
            
            if filter.filterName == "Color Cube" {
                     let grayscaleValue = Float(self.value)
                    let dimension: Int32 = 64
                let cubeData = self.generateColorCubeData(dimension: dimension, grayscaleValue: grayscaleValue)
                
                filter.filterType.setValue(dimension, forKey: "inputCubeDimension")
                filter.filterType.setValue(cubeData, forKey: "inputCubeData")
                filter.filterType.setValue(ciImage, forKey: kCIInputImageKey)
                        
            }
            
            // retreive filtered image
            guard let newImage = filter.filterType.outputImage else { return }
            
            
            DispatchQueue.main.async {
                completion(newImage)
            }
        }
    }
    
    
    
    
    func generateColorCubeData(dimension: Int32, grayscaleValue: Float) -> [Float] {
        var cubeData = [Float](repeating: 0, count: Int(dimension * dimension * dimension * 4))
        
        for z in 0..<dimension {
            for y in 0..<dimension {
                for x in 0..<dimension {
                    let offset = Int((z * dimension * dimension + y * dimension + x) * 4)
                    let value = Float(x) / Float(dimension - 1)
                    cubeData[offset] = Float(value * grayscaleValue) // Red channel
                    cubeData[offset + 1] = Float(value * grayscaleValue) // Green channel
                    cubeData[offset + 2] = Float(value * grayscaleValue) // Blue channel
                    cubeData[offset + 3] = 1.0 // Alpha channel
                }
            }
        }
        return cubeData
    }
}
