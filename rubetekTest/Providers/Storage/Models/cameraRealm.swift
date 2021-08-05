//
//  cameraRealm.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import RealmSwift

class cameraRealm : Object {
        
    @objc dynamic var name : String? = nil
    @objc dynamic var room : String? = nil
    @objc dynamic var snapshot : Data? = nil
    @objc dynamic var id = 0
    @objc dynamic var favorites = false
    @objc dynamic var rec = false
    
    convenience init(_ data : cameraCodable, snapshotData : Data? = nil) {
        self.init()
        self.id = data.id
        self.snapshot = snapshotData
        self.name = data.name ?? ""
        self.room = data.room ?? ""
        self.favorites = data.favorites ?? false
        self.rec = data.rec ?? false
    }
}
