//
//  Filters.swift
//  SwiftUI-ImageFilters
//
//  Created by Himanshu Sherkar on 16/10/23.
//

import SwiftUI

struct Filter: Identifiable {
    var id = UUID().uuidString
    var filterName: String
    var filterType: CIFilter
}

let builtInFilters : [Filter] = [
    .init(filterName: "Greyscale", filterType: CIFilter.photoEffectNoir()),
    .init(filterName: "Color Invert", filterType: CIFilter.colorInvert()),
    .init(filterName: "Sepia", filterType: CIFilter.sepiaTone()),
    .init(filterName: "Comic Effect", filterType: CIFilter.comicEffect()),
    .init(filterName: "Color Monochrome", filterType: CIFilter.colorMonochrome()),
    .init(filterName: "Crystalize", filterType: CIFilter.crystallize()),
    .init(filterName: "Gaussian Blur", filterType: CIFilter.gaussianBlur()),
    .init(filterName: "Bloom", filterType: CIFilter.bloom()),
    .init(filterName: "Color Posterize", filterType: CIFilter.colorPosterize()),
    .init(filterName: "Vintage", filterType: CIFilter.photoEffectFade()),
    .init(filterName: "Vignette", filterType: CIFilter.vignette()),
    .init(filterName: "Tonal Effect", filterType: CIFilter.photoEffectTonal()),
    .init(filterName: "Mono Effect", filterType: CIFilter.photoEffectMono()),
    .init(filterName: "Color Effect ", filterType: CIFilter.photoEffectChrome()),
    .init(filterName: "Warm Tone", filterType: CIFilter.photoEffectInstant()),
    .init(filterName: "Contrast", filterType: CIFilter.photoEffectProcess()),
    .init(filterName: "Pixelate", filterType: CIFilter.pixellate()),
    .init(filterName: "Hue", filterType: CIFilter.hueAdjust()),
    .init(filterName: "Dots", filterType: CIFilter.dotScreen()),
    .init(filterName: "Color Cross", filterType: CIFilter.colorCrossPolynomial()),
    .init(filterName: "Color Cube", filterType: CIFilter.colorCube())
]
