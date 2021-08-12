//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Ben Erekson on 8/11/21.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
