//
//  NoteViewController.swift
//  Swifty
//
//  Created by Kiran Surendran on 30/1/19.
//  Copyright © 2019 Quentiam. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController {

    var NoteArray = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = NoteArray[indexPath.row].content
        
        return cell
        
    }
    
    
    //MARK: - Persistent Data Storage Methods
    
    
    
    
    //MARK: - Button Events
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
    
}
