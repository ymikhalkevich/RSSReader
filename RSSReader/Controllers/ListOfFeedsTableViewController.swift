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
        
        ref.queryOrdered(byChild: "feeds-links").observe(.value, with: { snapshot in
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfFeeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedLinkCell", for: indexPath)
        
        cell.textLabel?.text = listOfFeeds[indexPath.row].feedLink
        toggleCellCheckbox(cell, isUsed: listOfFeeds[indexPath.row].isUsed)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let feedLink = listOfFeeds[indexPath.row]
            feedLink.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let feedLink = listOfFeeds[indexPath.row]
        let toggledIsUsed = !feedLink.isUsed
        toggleCellCheckbox(cell, isUsed: toggledIsUsed)
        feedLink.ref?.updateChildValues([
            "isUsed": toggledIsUsed
            ])
    }

    func toggleCellCheckbox(_ cell: UITableViewCell, isUsed: Bool) {
        if !isUsed {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .gray
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .black
        }
    }
    
    @IBAction func addFeedLinkButtonAction(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Feed Item",message: "Add an Feed",
        preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            let feedItem = LinkOfFeed(urlString: text, isUsed: true)
            let feedItemRef = self.ref.child("links\(self.listOfFeeds.count)")
            
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
