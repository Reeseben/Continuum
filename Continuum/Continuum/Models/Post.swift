//
//  Post.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit
import CloudKit

class Post {
    var photoData: Data?
    let timestamp: Date
    let caption: String
    var comments: [Comment]
    var photo: UIImage?{
        get{guard let photoData = photoData else { return nil }
            return UIImage(data: photoData) ?? nil }
        set{photoData = newValue?.jpegData(compressionQuality: 0.5)}}
    
    init(photoData: Data?, timestamp: Date = Date(), caption: String, comments: [Comment] = []) {
        self.photoData = photoData
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
    }
}
