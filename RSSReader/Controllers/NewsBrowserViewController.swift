//
//  NewsBrowserViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 9/2/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit

class NewsBrowserViewController: UIViewController {
    
    @IBOutlet weak var backToNewsButton: UIBarButtonItem!
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
            newsLinkDelegated = ""
        }
        else {
            print("incorrect URL")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
