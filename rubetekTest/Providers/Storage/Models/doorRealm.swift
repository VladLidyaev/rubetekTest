//
//  doorRealm.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import RealmSwift

class doorRealm : Object {
        
    @objc dynamic var name : String? = nil
    @objc dynamic var room : String? = nil
    @objc dynamic var snapshot : Data? = nil
    @objc dynamic var id = 0
    @objc dynamic var favorites = false
    
    convenience init(_ data : doorCodable, snapshotData : Data? = nil) {
        self.init()
        self.id = data.id
        self.snapshot = snapshotData
        self.name = data.name ?? ""
        self.room = data.room ?? ""
        self.favorites = data.favorites ?? false
    }
}
