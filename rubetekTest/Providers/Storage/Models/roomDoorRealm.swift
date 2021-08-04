//
//  roomDoorRealm.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import Realm
import RealmSwift

class roomDoorRealm : Object {
    
    @objc dynamic var name = ""
    let doors = List<doorRealm>()
    
    convenience init(_ name : String) {
        self.init()
        self.name = name
    }
}
