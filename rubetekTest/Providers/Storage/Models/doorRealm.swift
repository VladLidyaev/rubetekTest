//
//  doorRealm.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import Realm
import RealmSwift

class doorRealm : Object {
        
    @objc dynamic var name = ""
    @objc dynamic var room = ""
    @objc dynamic var snapshot = ""
    @objc dynamic var id = 0
    @objc dynamic var favorites = false
//    let inRoom = LinkingObjects(fromType: roomDoorRealm.self, property: "door")
    
    convenience init(_ data : door) {
        self.init()
        self.name = data.name ?? ""
        self.room = data.room ?? ""
        self.snapshot = data.snapshot ?? ""
        self.id = data.id
        self.favorites = data.favorites ?? false
    }
}
