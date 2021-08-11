//
//  PostError.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import Foundation

enum PostError: LocalizedError {
    case couldNotUnwrap
    case ckError(Error)
    
    var errorDescription: String? {
        switch self {
        case .couldNotUnwrap:
            return "Coudl not unwrap Object"
        case .ckError(let Error):
            return Error.localizedDescription
        }
    }
}
