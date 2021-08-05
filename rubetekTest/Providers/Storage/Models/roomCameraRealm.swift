//
//  roomCamera.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import RealmSwift

class roomCameraRealm : Object {
    
    @objc dynamic var name : String? = nil
    let cameras = List<cameraRealm>()
    
    convenience init(_ name : String? = nil) {
        self.init()
        self.name = name
    }
}
