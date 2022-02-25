//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Элина Рупова on 24.02.2022.
//

import UIKit

class NewNoteViewController: UIViewController, UITextViewDelegate {
    
    var currentNote: Note?
    
    @IBOutlet weak var headerTF: UITextField!
    @IBOutlet weak var textTF: UITextView!
    
    private var doneBarButton: UIBarButtonItem!
    private var isTextChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
        textTF.delegate = self
        textTF.textContainer.lineFragmentPadding = 0
        textTF.textContainerInset = .zero
        doneBarButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    private func saveNote() {
        guard let text = textTF.text, !text.isEmpty, isTextChanged else { return }
        guard var header = headerTF.text else { return }
        if header.isEmpty {
            let words = text.split(separator: " ")
            if words.count >= 2 {
                header = String(words[0]) + " " + String(words[1])
            } else {
                header = text
            }
        }
        
        if currentNote != nil {
            try! realm.write {
                currentNote?.text = text
                currentNote?.header = header
            }
        } else {
            let newNote = Note(text: text, header: header, date: Date())
            StorageManager.saveObject(newNote)
        }
    }

    private func setupEditScreen() {
        if currentNote != nil {
            textTF.text = currentNote?.text
            headerTF.text = currentNote?.header
            title = "Редактирование"
        } else {
            textTF.text = "Заметка"
            textTF.textColor = UIColor.lightGray
        }
    }
    
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textNoteLabel.textColor == UIColor.lightGray {
//            textNoteLabel.text = nil
//            textNoteLabel.textColor = UIColor.black
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Заметка"
            textView.textColor = UIColor.lightGray
            isTextChanged = false
        }
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isTextChanged = true
    }
   
    @IBAction func exitButtonPressed(_ sender: Any) {
        saveNote()
        self.dismiss(animated: true, completion: nil)
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
