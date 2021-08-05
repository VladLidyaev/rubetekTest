//
//  roomDoorRealm.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import RealmSwift

class roomDoorRealm : Object {
    
    @objc dynamic var name : String? = nil
    let doors = List<doorRealm>()
    
    convenience init(_ name : String? = nil) {
        self.init()
        self.name = name
    }
}
