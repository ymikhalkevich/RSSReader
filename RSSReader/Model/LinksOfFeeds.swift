//
//  File.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/28/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import Foundation

struct LinksOfFeeds  {
    
    private var listOfLinks: [URL?] = [nil]
    
    mutating func addUrl(url: URL) {
        listOfLinks.append(url)
    }
    
    func getStoredFeeddsCount () -> Int? {
        return listOfLinks.count
    }
    
}
