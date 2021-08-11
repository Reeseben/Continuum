//
//  PostController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class PostController {
    static var shared = PostController()
    
    var posts: [Post] = []
    
    func addComment(post: Post, text: String, completion: @escaping (Result<Comment, PostError>) -> Void){
        let newComment = Comment(text: text)
        post.comments.append(newComment)
        return completion(.success(newComment))
    }
    
    func createPostWith(caption: String, image: UIImage, completion: @escaping (Result<Post?, PostError>) -> Void){
        let data = image.jpegData(compressionQuality: 0.5)
        let post = Post(photoData: data, caption: caption)
        posts.append(post)
    }
    
    
    
}
