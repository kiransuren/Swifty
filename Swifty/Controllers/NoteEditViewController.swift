//
//  NoteEditViewController.swift
//  Swifty
//
//  Created by Kiran Surendran on 30/1/19.
//  Copyright © 2019 Quentiam. All rights reserved.
//

import UIKit
import CoreData

protocol AddNoteDelegate{
    func addItem(value: String?, isNew: Bool)
}

class NoteEditViewController: UIViewController {
    
    var isNew: Bool = true
    var oldValue: String = ""
    var delegate: AddNoteDelegate?
    @IBOutlet weak var noteTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.font = UIFont(name: "Helvetica Neue", size: 18)
        noteTextView.textColor = UIColor.black
        if !isNew{
            noteTextView.text = oldValue
            isNew = false
        }
        
    }
    

    override func willMove(toParent parent: UIViewController?) {                                        //Called when the current view is going to be popped off the stack
        super.willMove(toParent: parent)
        if parent == nil {
            //let newNote = Note(context: context)
            //newNote.content = noteTextView.text!
            //saveData()\
            delegate?.addItem(value: noteTextView.text!, isNew: isNew)
            print("Adding item to array")
            isNew = true

        }
    }


}
