//
//  ExtractionOption.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 29/12/25.
//

import Foundation

enum ExtractOption: String, Identifiable, CaseIterable {
    case empty = ""
    
    var id: String {
        self.rawValue
    }
}
