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
    
    private let converter = modelConverter.shared
    private let downloader = networkProvider.shared
    
    static var shared: storageProvider = {
        let provider = storageProvider()
        return provider
    }()
    
    
    private init() {
        start()
    }
    
    
    public func setFavorite(id: Int) {
        
        let realmDataBase = try! Realm()
        guard let element = realmDataBase.objects(doorRealm.self).filter({ $0.id == id }).first else { return }
        DispatchQueue.main.async {
            do {
                let realmDataBase = try! Realm()
                try realmDataBase.safeWrite({
                    element.favorites = true
                })
            } catch let error {
                print(error)
                return
            }
        }
    }
    
//    public func
    
    public func getDoorSection(update : Bool, completion: @escaping (Result<[doorSectionModel], Error>) -> Void) {
        
        if !update {
            let realmDataBase = try! Realm()
            var storageResult : [roomDoorRealm] = []
            let test = realmDataBase.objects(roomDoorRealm.self)
            test.forEach { (element) in
                storageResult.append(element)
            }
            
            guard storageResult.isEmpty else {
                completion(.success(converter.roomDoorRealmToDoorSectionModel(realmData: storageResult)))
                return
            }
        }
        
        self.updateAndGetDoorSection { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func getCameraSection(update : Bool, completion: @escaping (Result<[cameraSectionModel], Error>) -> Void) {
        
        if !update {
            let realmDataBase = try! Realm()
            var storageResult : [roomCameraRealm] = []
            let test = realmDataBase.objects(roomCameraRealm.self)
            test.forEach { (element) in
                storageResult.append(element)
            }
            
            guard storageResult.isEmpty else {
                completion(.success(converter.roomCameraRealmToCameraSectionModel(realmData: storageResult)))
                return
            }
        }
        
        self.updateAndGetCameraSection { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func updateAndGetDoorSection(completion: @escaping (Result<[doorSectionModel], Error>) -> Void) {
        
        downloader.getDoors { (result) in
            switch result {
            case .success(let data):
                
                self.deleteDoorData { (error) in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    
                    self.converter.doorListCodableToDoorSectionModel(codableData: data) { (result) in
                        completion(.success(result))
                    }
                    
                    self.converter.doorListCodableToRoomDoorRealm(codableData: data) { (result) in
                        DispatchQueue.main.async {
                            do {
                                let realmDataBase = try! Realm()
                                try realmDataBase.safeWrite({
                                    realmDataBase.add(result)
                                })
                            } catch let error {
                                completion(.failure(error))
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func updateAndGetCameraSection(completion: @escaping (Result<[cameraSectionModel], Error>) -> Void) {
        
        downloader.getCameras { (result) in
            switch result {
            case .success(let data):
                
                self.deleteCameraData { (error) in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    
                    self.converter.cameraListCodableToCameraSectionModel(codableData: data) { (result) in
                        completion(.success(result))
                    }
                    
                    self.converter.cameraListCodableToRoomCameraRealm(codableData: data) { (result) in
                        DispatchQueue.main.async {
                            do {
                                let realmDataBase = try! Realm()
                                try realmDataBase.safeWrite({
                                    realmDataBase.add(result)
                                })
                            } catch let error {
                                completion(.failure(error))
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    private func start() {
        
        print("==================================REALM==================================")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("=========================================================================")
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}})
        Realm.Configuration.defaultConfiguration = config
    }
    
    public func deleteDoorData(completion: @escaping(_ error : Error?) -> ()) {
        DispatchQueue.main.async {
            let realmDataBase = try! Realm()
            do {
                let objectsRoom = realmDataBase.objects(roomDoorRealm.self)
                try realmDataBase.safeWrite({
                    realmDataBase.delete(objectsRoom)
                })
                let objects = realmDataBase.objects(doorRealm.self)
                try realmDataBase.safeWrite({
                    realmDataBase.delete(objects)
                })
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
    
    public func deleteCameraData (completion: @escaping(_ error : Error?) -> ()) {
        DispatchQueue.main.async {
            let realmDataBase = try! Realm()
            do {
                let objectsRoom = realmDataBase.objects(roomCameraRealm.self)
                try realmDataBase.safeWrite({
                    realmDataBase.delete(objectsRoom)
                })
                let objects = realmDataBase.objects(cameraRealm.self)
                try realmDataBase.safeWrite({
                    realmDataBase.delete(objects)
                })
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
}

extension storageProvider: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
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
