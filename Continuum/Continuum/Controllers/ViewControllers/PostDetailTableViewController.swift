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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
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
        tableView.reloadData()
    }
    
}

