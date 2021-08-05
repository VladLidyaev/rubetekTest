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
    
    
    
    public func getDoorSection(completion: @escaping (Result<[doorSectionModel], Error>) -> Void) {
        
        let realmDataBase = try! Realm()
        var storageResult : [roomDoorRealm] = []
        let test = realmDataBase.objects(roomDoorRealm.self)
        test.forEach { (element) in
            storageResult.append(element)
        }
        
        guard storageResult.isEmpty else {
            completion(.success(converter.doorRoom(realmData: storageResult)))
            return
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
    
    
    public func getCameraSection(completion: @escaping (Result<[cameraSectionModel], Error>) -> Void) {
        
        let realmDataBase = try! Realm()
        var storageResult : [roomCameraRealm] = []
        let test = realmDataBase.objects(roomCameraRealm.self)
        test.forEach { (element) in
            storageResult.append(element)
        }
        
        guard storageResult.isEmpty else {
            completion(.success(converter.cameraRoom(realmData: storageResult)))
            return
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
                    
                    completion(.success(self.converter.doorRoom(codableData: data)))
                    let dataRealm : [roomDoorRealm] = self.converter.doorRoom(codableData: data)
                    DispatchQueue.main.async {
                        do {
                            let realmDataBase = try! Realm()
                            try realmDataBase.safeWrite({
                                realmDataBase.add(dataRealm)
                            })
                        } catch let error {
                            completion(.failure(error))
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
                    
                    completion(.success(self.converter.cameraRoom(codableData: data)))
                    let dataRealm : [roomCameraRealm] = self.converter.cameraRoom(codableData: data)
                    
                    DispatchQueue.main.async {
                        do {
                            let realmDataBase = try! Realm()
                            try realmDataBase.safeWrite({
                                realmDataBase.add(dataRealm)
                            })
                        } catch let error {
                            completion(.failure(error))
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
