//
//  SavedFilterModel.swift
//  SwiftUI-ImageFilters
//
//  Created by Varun Bagga on 20/10/23.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct SavedFilterModel: Identifiable{
    var id = UUID().uuidString
    var contrast: CGFloat
    var sharpness: CGFloat
    var brightness: CGFloat
    var saturation : CGFloat
    var filter : Filter
}
