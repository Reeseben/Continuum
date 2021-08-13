//
//  PostController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit
import CloudKit

class PostController {
    static var shared = PostController()
    
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func addComment(post: Post, text: String, completion: @escaping (Result<Comment, PostError>) -> Void){
        let reference = CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
        let newComment = Comment(text: text, postReference: reference)
//        post.comments.append(newComment)
        
        let record = CKRecord(comment: newComment, postReference: reference)
        
        publicDB.save(record) { ckRecord, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            print("Saved comment sucessfully to da cloud!")
            post.comments.append(newComment)
            post.commentCount += 1
            
            let ckPost = CKRecord(post: post)
            let updateRecord = CKModifyRecordsOperation(recordsToSave: [ckPost], recordIDsToDelete: nil)
            updateRecord.savePolicy = .changedKeys
            updateRecord.modifyRecordsCompletionBlock = { (records, _, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(.failure(.ckError(error)))
                }
                print("Sucessfully updated comment count on post!")
            }
            self.publicDB.add(updateRecord)
            
            return completion(.success(newComment))
            
        }
        
        return completion(.success(newComment))
        
    }
    
    func createPostWith(caption: String, image: UIImage, completion: @escaping (Result<Post?, PostError>) -> Void){
        let data = image.jpegData(compressionQuality: 0.5)
        let post = Post(photoData: data, caption: caption)
        posts.insert(post, at: 0)
        
        let record = CKRecord(post: post)
       
       publicDB.save(record) { ckRecord, error in
           if let error = error {
               print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
               return completion(.failure(.ckError(error)))
           }
           print("Saved record to cloud sucessfully")
           return completion(.success(post))
       }
       
       return completion(.success(post))
    }
    
    func fetchPosts(completion: @escaping (Result<[Post]?, PostError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard let records = results else { return }
            
            print("Records fetched sucessfully")
            
            self.posts = records.compactMap { Post(ckRecord: $0)}
            
            completion(.success(self.posts))
            
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping (Result<[Comment]?,PostError>) -> Void) {
        
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", commentConstants.ckRecordReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,predicate2])
        let query = CKQuery(recordType: "comment", predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let comments = records.compactMap { Comment(ckRecord: $0)}
            
            post.comments.append(contentsOf: comments)
            return completion(.success(post.comments))
        }
        
    }
    
}
