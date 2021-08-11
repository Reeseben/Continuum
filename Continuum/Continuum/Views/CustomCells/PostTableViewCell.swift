//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionTextLable: UILabel!
    @IBOutlet var commentCountTextLable: UILabel!
    
    
    //MARK: - Cell Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper Methods
    func updateViews(with post: Post) {
        postImageView.image = post.photo
        captionTextLable.text = post.caption
        commentCountTextLable.text = "Comments: \(post.comments.count)"
    }

}
