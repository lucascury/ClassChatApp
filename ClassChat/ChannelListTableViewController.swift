//
//  ChannelListTableViewController.swift
//  ClassChat
//
//  Created by Chris Gulley on 12/2/17.
//  Copyright © 2017 Chris Gulley. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChannelListTableViewController: UITableViewController {
    var database: DatabaseReference!
    var handle: UInt?
    var channels: [Channel] = []
    
    deinit {
        if let handle = handle {
            database.removeObserver(withHandle: handle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
    }
    
    func configureFirebase() {
        database = Database.database().reference()
        handle = database.child("channels").observe(.value) { [unowned self] snapshot in
            if let data = snapshot.value as? [String:[String:String]] {
                self.channels = Channel.parseFirebase(data: data)
            } else {
                self.channels = Channel.parseFirebase(data: [:])
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onChannelAdd(_ sender: Any) {
        let controller = UIAlertController(title: "Add Channel", message: nil, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "Channel name"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Add", style: .default) { action in
            if let name = controller.textFields![0].text {
                self.addChannel(name: name)
            }
        }
        
        controller.addAction(cancel)
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
    func addChannel(name: String) {
        database.child("channels").childByAutoId().setValue(["name": name])
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = channels[indexPath.row].name
        return cell
    }
}
