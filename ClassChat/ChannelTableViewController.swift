//
//  ChannelTableViewController.swift
//  ClassChat
//
//  Created by Chris Gulley on 12/2/17.
//  Copyright © 2017 Chris Gulley. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChannelTableViewController: UITableViewController {
    var channel: Channel!
    var database: DatabaseReference!
    var handle: UInt?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let channel = channel {
            self.navigationItem.title = channel.name
        }
        configureFirebase()
    }
    
    func configureFirebase() {
        database = Database.database().reference()
        handle = database.child("messages").child(channel.firebaseID).observe(.value) { [unowned self] snapshot in
            if let data = snapshot.value as? [String:[String:String]] {
                self.messages = Message.parseFirebase(data: data)
            } else {
                self.messages = Message.parseFirebase(data: [:])
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onAddMessage(_ sender: Any) {
        let controller = UIAlertController(title: "Add Message", message: nil, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "Message"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Add", style: .default) { action in
            if let message = controller.textFields![0].text {
                self.addMessage(text: message)
            }
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
    func addMessage(text: String) {
        database.child("messages").child(channel.firebaseID).childByAutoId().setValue(["text": text])
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = messages[indexPath.row].text
        return cell
    }
}
