//
//  NoteViewController.swift
//  Swifty
//
//  Created by Kiran Surendran on 30/1/19.
//  Copyright © 2019 Quentiam. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController, AddNoteDelegate {

    var NoteArray = [Note]()                                                                            //Array of Notes when app is running
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext       //Context referring to AppDelegate Persistent Data Storage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: - AddNote Delegate
    func addItem(value: String?) {
        let newNote = Note(context: context)
        newNote.content = value!
        NoteArray.append(newNote)
        saveData()
        tableView.reloadData()
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
    
    //MARK: - Swipe TableView Methods
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Ok item will be deleted")
            success(true)
            self.context.delete(self.NoteArray[indexPath.row])
            self.NoteArray.remove(at: indexPath.row)
            self.saveData()
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
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
        
        performSegue(withIdentifier: "toNoteEditor", sender: self)
        loadData()
        
    /*
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
            let heightConstraint = NSLayoutConstraint(item: field, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
            field.font = UIFont(name: "Verdana", size: 20)
            field.autocapitalizationType = UITextAutocapitalizationType.words
            field.spellCheckingType = UITextSpellCheckingType.yes
            field.addConstraint(heightConstraint)
            field.minimumFontSize = 30.0
            textField = field
            
        }
        
        present(alert, animated: true)
    */
        
    }
    
    
    //MARK: - Miscellaneous Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NoteEditViewController
        destination.delegate = self
    }
}
