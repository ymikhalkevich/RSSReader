//
//  ListOfFeedsTableViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/26/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit
import Firebase

class ListOfFeedsTableViewController: UITableViewController {
    
    var listOfFeeds : [LinkOfFeed] = []
    let ref = Database.database().reference(withPath: "feeds-links")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        ref.queryOrdered(byChild: "links").observe(.value, with: { snapshot in
            var newItems: [LinkOfFeed] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let linkFeed = LinkOfFeed(snapshot: snapshot) {
                    newItems.append(linkFeed)
                }
            }
            
            self.listOfFeeds = newItems
            self.tableView.reloadData()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfFeeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedLinkCell", for: indexPath)
        
        cell.textLabel?.text = listOfFeeds[indexPath.row].feedLink
        // Configure the cell...

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    @IBAction func addFeedLinkButtonAction(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Feed Item",message: "Add an Feed",
        preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            let feedItem = LinkOfFeed(urlString: text, isUsed: true)
            let feedItemRef = self.ref.child("links")
            
            feedItemRef.setValue(feedItem.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
