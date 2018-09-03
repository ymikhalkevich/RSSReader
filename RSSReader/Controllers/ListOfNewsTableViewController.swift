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

protocol GoToLinkStartable {
    var urlStringDelegate: String {get set}
}

class ListOfNewsTableViewController: UITableViewController {
    
    var newsLinkToDelegate = ""
    var listOfFeedsNews: [LinkOfFeed] = []
    let ref = Database.database().reference(withPath: "feeds-links")
    var cnt = 0
    var feedsLinkDatabaseUpdated = false
    var parseResultOfEachFeed : RSSFeed?
    var parseResultOfAllFeed : [RSSFeed?] = []
    
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
        
//        ref.queryOrdered(byChild: "feeds-links").observe(.value, with: { snapshot in
//            var newItems: [LinkOfFeed] = []
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                    let linkFeed = LinkOfFeed(snapshot: snapshot) {
//                    newItems.append(linkFeed)
//                }
//            }
//
//            self.listOfFeedsNews = newItems
//
//            for feedSource in self.listOfFeedsNews {
//                if feedSource.isUsed {
//
//                    var parser = FeedParser(URL: URL(string: feedSource.feedLink)!)
//                    parser.parseAsync { [weak self] (result) in
//                        if let rss = result.rssFeed {
//
//                            self?.parseResultOfEachFeed = rss
//
//                            self?.parseResultOfAllFeed.append(rss)
//
//                            DispatchQueue.main.async {
//                                self?.tableView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return parseResultOfAllFeed.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return parseResultOfAllFeed[section]?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (parseResultOfAllFeed[section]!.items?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath)
        cell.textLabel?.text = parseResultOfAllFeed[indexPath.section]?.items?[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let urlString = parseResultOfAllFeed[indexPath.section]?.items![indexPath.row].link
 
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let webViewNews = storyboard.instantiateViewController(withIdentifier: "NewsBrowserViewController") as? NewsBrowserViewController
//
//        webViewNews?.newsLinkDelegated = urlString!
        newsLinkToDelegate = urlString!
        
      //  performSegue(withIdentifier: "GoToNewsBrowser", with: nil)
      //  self.present(webViewNews!, animated: true, completion: nil)
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
    override func tableView(_ tableView: UITableView, mogit veRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
//
    override func viewWillAppear (_ animated: Bool) {
        
        parseResultOfAllFeed.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        
        ref.queryOrdered(byChild: "feeds-links").observe(.value, with: { snapshot in
            var newItems: [LinkOfFeed] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let linkFeed = LinkOfFeed(snapshot: snapshot) {
                    if linkFeed.isUsed {
                        newItems.append(linkFeed)
                    }
                }
            }
            
            self.listOfFeedsNews = newItems
        //    self?.parseResultOfEachFeed = nil
            for feedSource in self.listOfFeedsNews {
                
             //   self.parseResultOfEachFeed = nil
                
                var parser = FeedParser(URL: URL(string: feedSource.feedLink)!)
                
                var result = parser.parse()
                    if result.isSuccess {
                        if let rss = result.rssFeed {
                            
                          //  self.parseResultOfEachFeed = rss
                            self.parseResultOfAllFeed.append(rss)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    else {
                        print("ERROR: Feeds parser failed")
                    }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let identifier = segue.identifier {
            switch identifier {
            case "GoToNewsBrowser":
                if let newsBrowser = segue.destination as? NewsBrowserViewController {
                    newsBrowser.newsLinkDelegated = newsLinkToDelegate
                }
            default:
                break
            }
        }
    }

    deinit {
        print("News VC deinited")
    }
}
