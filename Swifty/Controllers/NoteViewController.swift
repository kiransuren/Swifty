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
    
    var aboutRequest: Bool = false
    var editNote: Bool = false
    var selIndexPathRow: Int = 0
    var NoteArray = [Note]()                                                                            //Array of Notes when app is running
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext       //Context referring to AppDelegate Persistent Data Storage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: - AddNote Delegate
    func addItem(value: String?, isNew: Bool) {
        if isNew{
            let newNote = Note(context: context)
            newNote.content = value!
            NoteArray.append(newNote)
            saveData()
            tableView.reloadData()
        }else{
            NoteArray[selIndexPathRow].content = value!
            saveData()
            tableView.reloadData()
        }
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
    
    //MARK: - TableView Methods
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editNote = true
        selIndexPathRow = indexPath.row
        performSegue(withIdentifier: "toNoteEditor", sender: self)
        
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
    }
    
    @IBAction func onAboutButtonPressed(_ sender: UIBarButtonItem) {
        aboutRequest = true
        performSegue(withIdentifier: "toAboutView", sender: self)
    }
    
    
    //MARK: - Miscellaneous Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if aboutRequest{
            aboutRequest = false
        }else{
            if editNote{
                editNote = false
                let destination = segue.destination as! NoteEditViewController
                destination.delegate = self
                destination.isNew = false
                destination.oldValue = NoteArray[selIndexPathRow].content!
            }else{
                let destination = segue.destination as! NoteEditViewController
                destination.delegate = self
            }        }
        
        
    }
}
