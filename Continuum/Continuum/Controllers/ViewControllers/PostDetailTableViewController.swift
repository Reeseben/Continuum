//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet var photoImageView: UIImageView!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Properties
    var post: Post? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let post = post else { return 0}
        return post.comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        guard let post = post else { return UITableViewCell()}
        
        cell.textLabel?.text = post.comments[indexPath.row].text
        cell.detailTextLabel?.text = post.comments[indexPath.row].timestamp.asString()
        
        return cell
    }
    
    //MARK: - Actions
    @IBAction func commentButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add new Comment", message: "What do you want to comment?", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.textFields?.first?.placeholder = "Type comment here"
        
        let okayAction = UIAlertAction(title: "Post", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty,
                  let post = self.post else { return }
            PostController.shared.addComment(post: post, text: text) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.tableView.reloadData()
                    case .failure(_):
                        print("Error adding new comment")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
        }
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let post = post,
              let image = post.photo else { return }
        let shareSheet = UIActivityViewController(activityItems: [post.caption, image], applicationActivities: nil)
        
        if let popoverController = shareSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction func followPostButtonTapped(_ sender: Any) {
        
    }
    
    
    //MARK: - Helper Methods
    func updateViews(){
        guard let post = post else { return }
        photoImageView.image = post.photo
        PostController.shared.fetchComments(for: post) { result in
            switch result {
            case .success(_):
                print("Sucessfully fetched \(post.comments.count) comments for post \(post.caption)")
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        tableView.reloadData()
    }
    
}

