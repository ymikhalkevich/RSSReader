//
//  NewsBrowserViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 9/2/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit

class NewsBrowserViewController: UIViewController {
    
    @IBOutlet weak var webViewNews: UIWebView!
    var newsLinkDelegated : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if newsLinkDelegated == "" {
            newsLinkDelegated = "https://www.google.com"
        }

        if let startUrl = URL(string: newsLinkDelegated) {
            let requestUrl = URLRequest(url: startUrl)
           webViewNews.loadRequest(requestUrl)
        }
        else {
            print("incorrect URL")
        }
        newsLinkDelegated = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
