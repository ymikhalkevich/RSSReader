//
//  File.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/28/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import Foundation
import Firebase

struct LinkOfFeed {
    let ref: DatabaseReference?
    let key: String
    var feedLink: String
    var isUsed: Bool
    
    init(urlString: String, isUsed: Bool, key: String = "") {
        self.ref = nil
        self.key = key
        self.feedLink = urlString
        self.isUsed = isUsed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let feedLink = value["feedLink"] as? String,
            let isUsed = value["isUsed"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.feedLink = feedLink
        self.isUsed = isUsed
    }
    
    func toAnyObject() -> Any {
        return [
            "feedLink": feedLink,
            "isUsed": isUsed
        ]
    }
}
