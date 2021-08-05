//
//  modelConverter.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation
import UIKit

class modelConverter {
    
    private let conf = configs.shared
    
    static var shared: modelConverter = {
        let converter = modelConverter()
        return converter
    }()
    
    private init() {}
    
    
    
    public func doorRoom(codableData : doorListCodable) -> [roomDoorRealm] {
        
        guard let doorArray = codableData.data else {
            return  []
        }
        
        var roomArray : [roomDoorRealm] = []
        self.getDoorDictionary(data: doorArray).forEach { (element) in
            
            var realmArray : [doorRealm] = []
            element.value.forEach { (doorCodableModel) in
                realmArray.append(self.door(codableModel: doorCodableModel))
            }
            let room = roomDoorRealm(element.key)
            room.doors.append(objectsIn: realmArray)
            roomArray.append(room)
        }
        return roomArray
    }
    
    public func doorRoom(codableData : doorListCodable) -> [doorSectionModel] {
        
        guard let doorArray = codableData.data else {
            return  []
        }
        
        var sectionArray : [doorSectionModel] = []
        self.getDoorDictionary(data: doorArray).forEach { (element) in
            
            var cellArray : [doorCellModel] = []
            element.value.forEach { (doorCodableModel) in
                cellArray.append(self.door(codableModel: doorCodableModel))
            }
            
            if element.key == nil {
                sectionArray.append(doorSectionModel(header: conf.defaulrRoom, items: cellArray))
            } else {
                sectionArray.append(doorSectionModel(header: element.key!, items: cellArray))
            }
        }
        return sectionArray
    }
    
    public func doorRoom(realmData : [roomDoorRealm]) -> [doorSectionModel] {
        
        var sectionArray : [doorSectionModel] = []
        realmData.forEach { (roomDoorRealm) in
            
            var cellModelArray : [doorCellModel] = []
            roomDoorRealm.doors.forEach { (door) in
                cellModelArray.append(self.door(realmModel: door))
            }
            
            if roomDoorRealm.name == nil {
                sectionArray.append(doorSectionModel(header: conf.defaulrRoom, items: cellModelArray))
            } else {
                sectionArray.append(doorSectionModel(header: roomDoorRealm.name!, items: cellModelArray))
            }
        }
        return sectionArray
    }
    
    
    
    public func cameraRoom(codableData : camerasListCodable) -> [roomCameraRealm] {
        
        guard let cameraArray = codableData.data?.cameras else {
            return  []
        }
        
        var roomArray : [roomCameraRealm] = []
        self.getCameraDictionary(data: cameraArray).forEach { (element) in
            
            var realmArray : [cameraRealm] = []
            element.value.forEach { (cameraCodableModel) in
                realmArray.append(self.camera(codableModel: cameraCodableModel))
            }
            let room = roomCameraRealm(element.key)
            room.cameras.append(objectsIn: realmArray)
            roomArray.append(room)
        }
        return roomArray
    }
    
    public func cameraRoom(codableData : camerasListCodable) -> [cameraSectionModel] {
        
        guard let cameraArray = codableData.data?.cameras else {
            return  []
        }
        
        var sectionArray : [cameraSectionModel] = []
        self.getCameraDictionary(data: cameraArray).forEach { (element) in
            
            var cellArray : [cameraCellModel] = []
            element.value.forEach { (cameraCodableModel) in
                cellArray.append(self.camera(codableModel: cameraCodableModel))
            }
            
            if element.key == nil {
                sectionArray.append(cameraSectionModel(header: conf.defaulrRoom, items: cellArray))
            } else {
                sectionArray.append(cameraSectionModel(header: element.key!, items: cellArray))
            }
        }
        return sectionArray
    }
    
    public func cameraRoom(realmData : [roomCameraRealm]) -> [cameraSectionModel] {
        
        var sectionArray : [cameraSectionModel] = []
        realmData.forEach { (roomCameraRealm) in
            
            var cellModelArray : [cameraCellModel] = []
            roomCameraRealm.cameras.forEach { (camera) in
                cellModelArray.append(self.camera(realmModel: camera))
            }
            
            if roomCameraRealm.name == nil {
                sectionArray.append(cameraSectionModel(header: conf.defaulrRoom, items: cellModelArray))
            } else {
                sectionArray.append(cameraSectionModel(header: roomCameraRealm.name!, items: cellModelArray))
            }
        }
        return sectionArray
    }
    
    
    
    private func getCameraDictionary(data : [cameraCodable]) -> [ String? : [cameraCodable]] {
        
        var cameraDictionary : [ String? : [cameraCodable]] = [:]
        data.forEach { (camera) in
            
            if cameraDictionary.keys.contains(camera.room) {
                cameraDictionary[camera.room]!.append(camera)
            } else {
                cameraDictionary.updateValue([camera], forKey: camera.room)
            }
        }
        return cameraDictionary
    }
    
    private func getDoorDictionary(data : [doorCodable]) -> [ String? : [doorCodable]] {
        
        var doorDictionary : [ String? : [doorCodable]] = [:]
        data.forEach { (door) in
            
            if doorDictionary.keys.contains(door.room) {
                doorDictionary[door.room]!.append(door)
            } else {
                doorDictionary.updateValue([door], forKey: door.room)
            }
        }
        return doorDictionary
    }
    
    private func door(codableModel : doorCodable) -> doorRealm {
        let realmModel = doorRealm(codableModel)
        return realmModel
    }
    
    private func door(codableModel : doorCodable) -> doorCellModel {
        let cellModel = doorCellModel(id: codableModel.id,
                                      name: codableModel.name ?? conf.defaultName,
                                      snapshot: self.getImageByURL(url: codableModel.snapshot, optional: true),
                                      room: codableModel.room ?? conf.defaulrRoom,
                                      favorites: codableModel.favorites ?? false)
        return cellModel
    }
    
    private func door(realmModel : doorRealm) -> doorCellModel {
        let cellModel = doorCellModel(id: realmModel.id,
                                      name: realmModel.name ?? conf.defaultName,
                                      snapshot: self.getImageFromData(data: realmModel.snapshot, optional: true),
                                      room: realmModel.room ?? conf.defaulrRoom,
                                      favorites: realmModel.favorites )
        return cellModel
    }
    
    
    
    private func camera(codableModel : cameraCodable) -> cameraRealm {
        let realmModel = cameraRealm(codableModel)
        return realmModel
    }
    
    private func camera(codableModel : cameraCodable) -> cameraCellModel {
        let cellModel = cameraCellModel(id: codableModel.id,
                                        name: codableModel.name ?? conf.defaultName,
                                        snapshot: self.getImageByURL(url: codableModel.snapshot, optional: false)!,
                                        room: codableModel.room ?? conf.defaulrRoom,
                                        favorites: codableModel.favorites ?? false,
                                        rec: codableModel.rec ?? false)
        return cellModel
    }
    
    private func camera(realmModel : cameraRealm) -> cameraCellModel {
        let cellModel = cameraCellModel(id: realmModel.id,
                                        name: realmModel.name ?? conf.defaultName,
                                        snapshot: self.getImageFromData(data: realmModel.snapshot, optional: false)!,
                                        room: realmModel.room ?? conf.defaulrRoom,
                                        favorites: realmModel.favorites,
                                        rec: realmModel.rec)
        return cellModel
    }
    
    private func getImageByURL(url : String?, optional : Bool) -> UIImage? {
        
        guard let url = url else {
            if optional {
                return nil
            } else {
                return conf.defaultImage
            }
        }
        
        let semaphore = DispatchSemaphore(value: 1)
        var image = UIImage()
        networkProvider.shared.getImage(imageURL: url) { (result) in
            switch result {
            case .success(let data):
                image = UIImage(data: data, scale: 1) ?? self.conf.defaultImage
            case .failure(_):
                image = self.conf.defaultImage
            }
            semaphore.signal()
        }
        semaphore.wait()
        return image
    }
    
    private func getImageFromData(data : Data?, optional : Bool) -> UIImage? {
        
        guard let data = data else {
            if optional {
                return nil
            } else {
                return conf.defaultImage
            }
        }
        
        let image = UIImage(data: data)
        if image != nil {
            return image!
        } else {
            return conf.defaultImage
        }
    }
}

extension modelConverter: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
