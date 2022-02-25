//
//  ViewController.swift
//  Notes
//
//  Created by Элина Рупова on 24.02.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var notes: Results<Note>!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = realm.objects(Note.self)
        if notes.isEmpty {
            addFirstNote() 
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.table.reloadData()
    }

    @IBAction func addTask(_ sender: Any) {
        self.table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = table.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
//            navigationVC.modalTransitionStyle = .coverVertical
            let newNoteVC = navigationVC.topViewController as! NewNoteViewController
            newNoteVC.currentNote = note
        }
    }
    
    func addFirstNote() {
        let newNote = Note()
        newNote.text = "Добро пожаловать в Заметки!"
        newNote.header = "Заметка"
        newNote.date = Date()
        StorageManager.saveObject(newNote)
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.isEmpty ? 0 : notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NoteTableViewCell
        var note = Note()
        note = notes[indexPath.row]

        cell.headerLabel.text = note.header
        cell.noteLabel.text = note.text
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateResult = formatter.string(from: note.date)
        cell.dateLabel.text = dateResult
    
        return cell

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            StorageManager.deleteObject(note: note)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
