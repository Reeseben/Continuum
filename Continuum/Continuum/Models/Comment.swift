//
//  Comment.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import Foundation
import CloudKit

struct commentConstants {
    static let reocrdTypeKey = "comment"
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let ckRecordReferenceKey = "reference"
}

class Comment {
    let text: String
    let timestamp: Date
    var recordID: CKRecord.ID
    let postReference: CKRecord.Reference?
    
    init(text: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), postReference: CKRecord.Reference) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.postReference = postReference
    }
}

extension CKRecord {
    convenience init(comment: Comment, postReference: CKRecord.Reference) {
        self.init(recordType: commentConstants.reocrdTypeKey, recordID: comment.recordID)
        
        self.setValuesForKeys([
            commentConstants.textKey: comment.text,
            commentConstants.timestampKey: comment.timestamp,
            commentConstants.ckRecordReferenceKey: comment.postReference!
        ])
        
    }
}

extension Comment {
    convenience init?(ckRecord: CKRecord){
        guard let text = ckRecord[commentConstants.textKey] as? String,
              let timestamp = ckRecord[commentConstants.timestampKey] as? Date,
              let postReference = ckRecord[commentConstants.ckRecordReferenceKey] as? CKRecord.Reference else { return nil}
        
        self.init(text: text, timestamp: timestamp, recordID: ckRecord.recordID, postReference: postReference)
    }
}
