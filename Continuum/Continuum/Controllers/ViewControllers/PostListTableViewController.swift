//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class PostListTableViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        resultsArray = PostController.shared.posts
    }
    
    //MARK: - Properties
    var resultsArray: [SearchableRecord] = []
    var isSearching: Bool = false
    var dataSource: [SearchableRecord] {
        if isSearching {
            return resultsArray
        } else {
            return PostController.shared.posts
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        
        guard let post = dataSource[indexPath.row] as? Post else { return UITableViewCell()}
        
        cell.updateViews(with: post)
        
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
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            guard let destination = segue.destination as? PostDetailTableViewController,
                  let index = tableView.indexPathForSelectedRow?.row,
                  let post = dataSource[index] as? Post else { return }
            destination.post = post
        }
    }
    
    
}

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultsArray = PostController.shared.posts
            self.tableView.reloadData()
        } else {
            resultsArray = PostController.shared.posts.filter { post in
                if post.matches(searchTerm: searchText) {
                    return true
                } else {
                    return false
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        self.tableView.reloadData()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
    }
    
}
