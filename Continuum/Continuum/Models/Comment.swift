//
//  Comment.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import Foundation

class Comment {
    let text: String
    let timestamp: Date
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
}
