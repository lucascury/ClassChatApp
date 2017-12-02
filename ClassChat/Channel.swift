//
//  Channel.swift
//  ClassChat
//
//  Created by Chris Gulley on 12/2/17.
//  Copyright © 2017 Chris Gulley. All rights reserved.
//

import Foundation

class Channel {
    let name: String
    let firebaseID: String
    
    init(name: String, firebaseID: String) {
        self.name = name
        self.firebaseID = firebaseID
    }
    
    class func parseFirebase(data: [String:[String:String]]) -> [Channel] {
        var channels: [Channel] = []
        for (key, value) in data {
            if let name = value["name"] {
                let channel = Channel(name: name, firebaseID: key)
                channels.append(channel)
            }
        }
        return channels
    }
    
}
