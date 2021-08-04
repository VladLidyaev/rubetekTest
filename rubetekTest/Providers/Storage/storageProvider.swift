//
//  storageProvider.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation
import Realm
import RealmSwift

class storageProvider {
    
    public func start(completion: @escaping(_ error : Error?) -> ()) {
        print("==================================REALM==================================")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("=========================================================================")
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        Realm.Configuration.defaultConfiguration = config
        completion(nil)
    }
    
    
    public func setData() {
        
        self.start { (_) in
            
            networkProvider.getDoors { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let data):
                    
                    let realm = try! Realm()
                    
                    guard let doorArray = data.data else { return }
                    var doorDictionary : [ String : [door]] = [:]
                    doorArray.forEach { (door) in
                        
                        guard let room = door.room else {
                            if doorDictionary.keys.contains("") {
                                doorDictionary[""]!.append(door)
                            } else {
                                doorDictionary.updateValue([door], forKey: "")
                            }
                            return
                        }
                        
                        if doorDictionary.keys.contains(room) {
                            doorDictionary[door.room!]!.append(door)
                        } else {
                            doorDictionary.updateValue([door], forKey: door.room!)
                        }
                    }
                    
                    
                    
                    doorDictionary.forEach { (room) in
                        
                        var arrayOfDoors : [doorRealm] = []
                        
                        room.value.forEach { (door) in
                            let doorDB = doorRealm(door)
                            arrayOfDoors.append(doorDB)
                        }
                        
                        let roomDB = roomDoorRealm(room.key)
                        roomDB.doors.append(objectsIn: arrayOfDoors)
                        
                        try! realm.write {
                            realm.add(roomDB)
                        }
                    }
                    
                    print(realm.isEmpty)
                }
            }
        }
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
