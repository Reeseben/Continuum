//
//  DateFormatter.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import Foundation

extension Date {
    func asString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
