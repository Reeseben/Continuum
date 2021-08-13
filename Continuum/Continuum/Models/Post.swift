//
//  Post.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit
import CloudKit

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timestampKey = "timestamp"
    static let commentsKey = "comments"
    static let photoKey = "photo"
    static let commentCountKey = "commentcount"
}

class Post {
    var photoData: Data?
    let timestamp: Date
    let caption: String
    var comments: [Comment]
    var commentCount: Int
    var recordID: CKRecord.ID
    var photo: UIImage?{
        get{guard let photoData = photoData else { return nil }
            return UIImage(data: photoData) ?? nil }
        set{photoData = newValue?.jpegData(compressionQuality: 0.5)}}
    
    var imageAsset: CKAsset? {
        get{
            guard photoData != nil else { return nil}
            
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    
    init(photoData: Data?, timestamp: Date = Date(), caption: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), comments: [Comment] = [], commentCount: Int = 0) {
        self.photoData = photoData
        self.timestamp = timestamp
        self.caption = caption
        self.recordID = recordID
        self.comments = comments
        self.commentCount = commentCount
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return caption.lowercased().contains(searchTerm.lowercased())
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostConstants.typeKey, recordID: post.recordID)
        
        self.setValuesForKeys([
            PostConstants.captionKey : post.caption,
            PostConstants.timestampKey : post.timestamp,
            PostConstants.commentCountKey : post.commentCount
        ])
        
        if let postPhoto = post.imageAsset {
            self.setValue(postPhoto, forKey: PostConstants.photoKey)
        }
    }
}

extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
              let caption = ckRecord[PostConstants.captionKey] as? String,
              let commentCount = ckRecord[PostConstants.commentCountKey] as? Int else { return nil}
        
        
        guard let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset else { return nil}

        var data: Data?
        
        do {
            try data = Data(contentsOf: photoAsset.fileURL!)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
        
        guard let data = data else { return nil}
        
        self.init(photoData: data, timestamp: timestamp, caption: caption, recordID: ckRecord.recordID, commentCount: commentCount)
        
    }
}
