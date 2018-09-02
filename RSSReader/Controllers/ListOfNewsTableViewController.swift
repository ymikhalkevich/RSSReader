//
//  ListOfNewsTableViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/26/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FeedKit

class ListOfNewsTableViewController: UITableViewController {
    
    var listOfFeedsNews : [LinkOfFeed] = []
    let ref = Database.database().reference(withPath: "feeds-links")
    
    var parseResultOfEachFeed : RSSFeed?
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBAction func signOutButtonAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "GoToLogout", sender: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        
        //  self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ref.queryOrdered(byChild: "feeds-links").observe(.value, with: { snapshot in
            var newItems: [LinkOfFeed] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let linkFeed = LinkOfFeed(snapshot: snapshot) {
                    newItems.append(linkFeed)
                }
            }
            
            self.listOfFeedsNews = newItems
            
            for feedSource in self.listOfFeedsNews {
                if feedSource.isUsed {
                    
                    var parser = FeedParser(URL: URL(string: feedSource.feedLink)!)
                    
                    parser.parseAsync { [weak self] (result) in
                        
                        if let rss = result.rssFeed {
                        
                            self?.parseResultOfEachFeed = rss
                            
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var feedsToDisplayConter = Int()
        for feedNews in listOfFeedsNews {
            if feedNews.isUsed {
                feedsToDisplayConter += 1
            }
        }
        return feedsToDisplayConter
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return listOfFeedsNews[section].feedLink
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        print ("description = \(parseResultOfEachFeed?.description), count= \(parseResultOfEachFeed?.items?.count)")
        
        return (parseResultOfEachFeed!.items?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        cell.textLabel?.text = parseResultOfEachFeed?.items?[indexPath.row].title
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        print("News VC deinited")
    }
}
