//
//  FilterImage.swift
//  SwiftUI-ImageFilters
//
//  Created by Himanshu Sherkar on 16/10/23.
//

import SwiftUI

struct FilteredImage: Identifiable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: Filter
    var isEditable: Bool
}
