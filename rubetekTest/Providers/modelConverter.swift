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
    private let baseQueue = DispatchQueue(label: "storageProvider.imageDownload", qos: .background, attributes: .concurrent)
    
    static var shared: modelConverter = {
        let converter = modelConverter()
        return converter
    }()
    
    private init() {}
    
    
    
    public func doorListCodableToRoomDoorRealm(codableData : doorListCodable, completion: @escaping ([roomDoorRealm]) -> Void) {
        
        baseQueue.async {
            guard let doorArray = codableData.data else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var roomArray : [roomDoorRealm] = []
            self.getDoorDictionary(data: doorArray).forEach { (element) in
                
                var realmArray : [doorRealm] = []
                element.value.forEach { (doorCodableModel) in
                    group.enter()
                    self.doorCodableToDoorRealm(codableModel: doorCodableModel) { (doorRealm) in
                        realmArray.append(doorRealm)
                        group.leave()
                    }
                }
                group.wait()
                let room = roomDoorRealm(element.key)
                room.doors.append(objectsIn: realmArray)
                roomArray.append(room)
            }
            group.notify(queue: self.baseQueue) {
                completion(roomArray)
            }
        }
    }
    
    public func doorListCodableToDoorSectionModel(codableData : doorListCodable, completion: @escaping ([doorSectionModel]) -> Void) {
        
        baseQueue.async {
            guard let doorArray = codableData.data else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var sectionArray : [doorSectionModel] = []
            self.getDoorDictionary(data: doorArray).forEach { (element) in
                
                var cellArray : [doorCellModel] = []
                element.value.forEach { (doorCodableModel) in
                    group.enter()
                    self.doorCodableToDoorCellModel(codableModel: doorCodableModel) { (doorCellModel) in
                        cellArray.append(doorCellModel)
                        group.leave()
                    }
                }
                group.wait()
                if element.key == nil {
                    sectionArray.append(doorSectionModel(header: self.conf.defaulrRoom, items: cellArray))
                } else {
                    sectionArray.append(doorSectionModel(header: element.key!, items: cellArray))
                }
            }
            group.notify(queue: self.baseQueue) {
                completion(sectionArray.sorted { $0.header < $1.header })
            }
        }
    }
    
    public func roomDoorRealmToDoorSectionModel(realmData : [roomDoorRealm]) -> [doorSectionModel] {
        
        var sectionArray : [doorSectionModel] = []
        realmData.forEach { (roomDoorRealm) in
            
            var cellModelArray : [doorCellModel] = []
            roomDoorRealm.doors.forEach { (door) in
                cellModelArray.append(self.doorRealmToDoorCellModel(realmModel: door))
            }
            
            if roomDoorRealm.name == nil {
                sectionArray.append(doorSectionModel(header: conf.defaulrRoom, items: cellModelArray))
            } else {
                sectionArray.append(doorSectionModel(header: roomDoorRealm.name!, items: cellModelArray))
            }
        }
        return sectionArray.sorted { $0.header < $1.header }
    }
    
    
    
    public func cameraListCodableToRoomCameraRealm(codableData : camerasListCodable, completion: @escaping ([roomCameraRealm]) -> Void) {
        
        baseQueue.async {
            guard let cameraArray = codableData.data?.cameras else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var roomArray : [roomCameraRealm] = []
            self.getCameraDictionary(data: cameraArray).forEach { (element) in
                
                var realmArray : [cameraRealm] = []
                element.value.forEach { (cameraCodableModel) in
                    group.enter()
                    self.cameraCodableToCameraRealm(codableModel: cameraCodableModel) { (cameraRealm) in
                        realmArray.append(cameraRealm)
                        group.leave()
                    }
                }
                group.wait()
                let room = roomCameraRealm(element.key)
                room.cameras.append(objectsIn: realmArray)
                roomArray.append(room)
            }
            group.notify(queue: self.baseQueue) {
                completion(roomArray)
            }
        }
    }
    
    public func cameraListCodableToCameraSectionModel(codableData : camerasListCodable, completion: @escaping ([cameraSectionModel]) -> Void) {
        
        baseQueue.async {
            guard let cameraArray = codableData.data?.cameras else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            var sectionArray : [cameraSectionModel] = []
            self.getCameraDictionary(data: cameraArray).forEach { (element) in
                
                var cellArray : [cameraCellModel] = []
                element.value.forEach { (cameraCodableModel) in
                    group.enter()
                    self.cameraCodableToCameraCellModel(codableModel: cameraCodableModel) { (cameraCellModel) in
                        cellArray.append(cameraCellModel)
                        group.leave()
                    }
                }
                group.wait()
                if element.key == nil {
                    sectionArray.append(cameraSectionModel(header: self.conf.defaulrRoom, items: cellArray))
                } else {
                    sectionArray.append(cameraSectionModel(header: element.key!, items: cellArray))
                }
            }
            group.notify(queue: self.baseQueue) {
                completion(sectionArray.sorted { $0.header < $1.header })
            }
        }
    }
    
    public func roomCameraRealmToCameraSectionModel(realmData : [roomCameraRealm]) -> [cameraSectionModel] {
        
        var sectionArray : [cameraSectionModel] = []
        realmData.forEach { (roomCameraRealm) in
            
            var cellModelArray : [cameraCellModel] = []
            roomCameraRealm.cameras.forEach { (camera) in
                cellModelArray.append(self.cameraRealmToCameraCellModel(realmModel: camera))
            }
            
            if roomCameraRealm.name == nil {
                sectionArray.append(cameraSectionModel(header: conf.defaulrRoom, items: cellModelArray))
            } else {
                sectionArray.append(cameraSectionModel(header: roomCameraRealm.name!, items: cellModelArray))
            }
        }
        return sectionArray.sorted { $0.header < $1.header }
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
    
    
    
    private func doorCodableToDoorRealm(codableModel : doorCodable, completion: @escaping (doorRealm) -> Void) {
        self.getImageByURL(url: codableModel.snapshot, optional: true) { (image) in
            completion(doorRealm(codableModel, snapshotData: image?.pngData()))
        }
    }
    
    private func doorCodableToDoorCellModel(codableModel : doorCodable, completion: @escaping (doorCellModel) -> Void) {
        self.getImageByURL(url: codableModel.snapshot, optional: true) { (image) in
            completion(doorCellModel(id: codableModel.id,
                                     name: codableModel.name ?? self.conf.defaultName,
                                     snapshot: image,
                                     room: codableModel.room ?? self.conf.defaulrRoom,
                                     favorites: codableModel.favorites ?? false))
        }
    }
    
    private func doorRealmToDoorCellModel(realmModel : doorRealm) -> doorCellModel {
        let cellModel = doorCellModel(id: realmModel.id,
                                      name: realmModel.name ?? conf.defaultName,
                                      snapshot: self.getImageFromData(data: realmModel.snapshot, optional: true),
                                      room: realmModel.room ?? conf.defaulrRoom,
                                      favorites: realmModel.favorites )
        return cellModel
    }
    
    
    
    private func cameraCodableToCameraRealm(codableModel : cameraCodable, completion: @escaping (cameraRealm) -> Void) {
        self.getImageByURL(url: codableModel.snapshot, optional: false) { (image) in
            completion(cameraRealm(codableModel, snapshotData: image!.pngData()!))
        }
    }
    
    private func cameraCodableToCameraCellModel(codableModel : cameraCodable, completion: @escaping (cameraCellModel) -> Void) {
        self.getImageByURL(url: codableModel.snapshot, optional: false) { (image) in
            completion(cameraCellModel(id: codableModel.id,
                                       name: codableModel.name ?? self.conf.defaultName,
                                       snapshot: image!,
                                       room: codableModel.room ?? self.conf.defaulrRoom,
                                       favorites: codableModel.favorites ?? false,
                                       rec: codableModel.rec ?? false))
        }
    }
    
    private func cameraRealmToCameraCellModel(realmModel : cameraRealm) -> cameraCellModel {
        let cellModel = cameraCellModel(id: realmModel.id,
                                        name: realmModel.name ?? conf.defaultName,
                                        snapshot: self.getImageFromData(data: realmModel.snapshot, optional: false)!,
                                        room: realmModel.room ?? conf.defaulrRoom,
                                        favorites: realmModel.favorites,
                                        rec: realmModel.rec)
        return cellModel
    }
    
    private func getImageByURL(url : String?, optional : Bool, completion: @escaping (UIImage?) -> Void) {
        
        
        guard let url = url else {
            if optional {
                completion(nil)
            } else {
                completion(conf.defaultImage)
            }
            return
        }
        
        networkProvider.shared.getImage(imageURL: url) { (result) in
            switch result {
            case .success(let data):
                completion(UIImage(data: data, scale: 1) ?? self.conf.defaultImage)
                break
            case .failure(_):
                completion(self.conf.defaultImage)
            }
        }
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
