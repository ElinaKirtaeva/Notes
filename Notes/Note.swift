//
//  Note.swift
//  Notes
//
//  Created by Элина Рупова on 24.02.2022.
//

import RealmSwift

class Note: Object {
    @objc dynamic var text: String?
    @objc dynamic var header: String?
    @objc dynamic var date = Date()
  
    convenience init(text: String, header: String, date: Date) {
        self.init()
        self.text = text
        self.header = header
        self.date = date
    }
}

