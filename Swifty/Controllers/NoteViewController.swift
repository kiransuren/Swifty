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

    var NoteArray = [Note]()                                                                            //Array of Notes when app is running
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext       //Context referring to AppDelegate Persistent Data Storage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
    //Saves context (to core data)
    func saveData(){
        do{
            try context.save()
        }catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    //Loads data from Core Data to NoteArray
    func loadData(){
        let request: NSFetchRequest = Note.fetchRequest()           //Fetch request that gets all data (no predicate)
        
        do{
            NoteArray = try context.fetch(request)
        }catch{
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Button Events
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new note", message: "", preferredStyle: .alert)           //Alert controller popup
        let action = UIAlertAction(title: "Add", style: .default) { (action) in                             //When add button is pressed
            let newNote = Note(context: self.context)                                                       //Create new note value
            newNote.content = textField.text!                                                               //Add content value
        
            self.NoteArray.append(newNote)
            self.saveData()                                                                                 //Save Data
        
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            field.placeholder = "Enter a new note"
            textField = field
        }
        
        present(alert, animated: true)
        
    }
    
}
