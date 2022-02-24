//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Элина Рупова on 24.02.2022.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var headerTF: UITextField!
    @IBOutlet weak var textNoteLabel: UITextView!
    var currentNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    private func saveNote() {
        guard let text = textNoteLabel.text else { return }
        if text.isEmpty { return }
        guard var header = headerTF.text else { return }
        if header.isEmpty {
            let words = text.split(separator: " ")
            if words.count >= 2 {
                header = String(words[0]) + " " + String(words[1])
            } else {
                header = text
            }
        }
        
        let newNote = Note(text: text, header: header, date: Date())
        if currentNote != nil {
            try! realm.write {
                currentNote?.text = text
                currentNote?.header = header
            }
        } else {
            StorageManager.saveObject(newNote)
        }
    }

    private func setupEditScreen() {
        if currentNote != nil {
            textNoteLabel.text = currentNote?.text
            headerTF.text = currentNote?.header
            title = "Редактирование"
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        saveNote()
        if currentNote != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Выбрать фото", style: .default) { _ in
            self.chooseImagePicker(sourse: .photoLibrary)
        }
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let photo = UIAlertAction(title: "Снять фото", style: .default) { _ in
            self.chooseImagePicker(sourse: .camera)
        }
        photo.setValue(UIImage(systemName: "photo.artframe"), forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

extension NewNoteViewController {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
}
