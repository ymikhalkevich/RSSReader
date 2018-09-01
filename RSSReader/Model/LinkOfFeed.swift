//
//  File.swift
//  RSSReader
//
//  Created by Yury Mikhalkevich on 8/28/18.
//  Copyright © 2018 Yury Mikhalkevich. All rights reserved.
//

import Foundation
import Firebase

class LinkOfFeed  {
    let ref: DatabaseReference?
    let key: String
    var feddLink: String
    var isUsed: Bool
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let feedLink = value["feedLink"] as? String,
            let isUsed = value["isUsed"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.feddLink = feddLink
        self.isUsed = isUsed
    }
    
    init(urlString: String, isUsed: Bool) {
        self.ref = nil
        self.feddLink = urlString
        self.isUsed = isUsed
    }
    
    func toAnyObject() -> Any {
        return [
            "feedLink": feedLink,
            "isUsed": isUsed
        ]
    }
}
