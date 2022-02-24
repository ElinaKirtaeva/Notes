//
//  StorageManager.swift
//  Notes
//
//  Created by Элина Рупова on 24.02.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ note: Note) {
        try! realm.write {
            realm.add(note)
        }
    }
    
    static func deleteObject(note: Note) {
        try! realm.write{
            realm.delete(note)
        }
    }
}
