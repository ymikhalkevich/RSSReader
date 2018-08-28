//
//  BrowserViewController.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/28/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var backToFeedsButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let application = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        if let startUrl = URL(string: "https://www.google.com") {
            let requestUrl = URLRequest(url: startUrl)
            webView.loadRequest(requestUrl)
        }
        else {
              print("incorrect URL")
        }
        
       
        // Do any additional setup after loading the view.
    }

    func isActivityIndicator(works: Bool, indicator: UIActivityIndicatorView) {
        application.isNetworkActivityIndicatorVisible = works
        if works {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        isActivityIndicator(works: true, indicator: activityIndicator)
        self.backwardButton.isEnabled = false
        self.forwardButton.isEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        isActivityIndicator(works: false, indicator: activityIndicator)
        if webView.canGoForward {
            self.forwardButton.isEnabled = true
        } else if webView.canGoBack {
                self.backwardButton.isEnabled = true
            }
        }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardBtnAction(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction func refreshBtnAction(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
