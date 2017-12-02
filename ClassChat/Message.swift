//
//  Message.swift
//  ClassChat
//
//  Created by Chris Gulley on 12/2/17.
//  Copyright © 2017 Chris Gulley. All rights reserved.
//

import Foundation

class Message {
    let text: String
    let firebaseID: String
    
    init(text: String, firebaseID: String) {
        self.text = text
        self.firebaseID = firebaseID
    }
    
    class func parseFirebase(data: [String:[String:String]]) -> [Message] {
        var messages: [Message] = []
        for (key, value) in data {
            if let text = value["text"] {
                let message = Message(text: text, firebaseID: key)
                messages.append(message)
            }
        }
        return messages
    }
    
}
