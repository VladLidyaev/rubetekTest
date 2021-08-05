//
//  configs.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation
import UIKit

enum menuPages : String, CaseIterable {
    case cameras = "Камеры"
    case doors = "Двери"
}

class configs {
    
    public let baseURL = "https://cars.cprogroup.ru/api/rubetek"
    public var selectorAnimationTime : TimeInterval = 0.2
    
    public let cameraCellId = "cameraCell"
    public let doorCellId = "doorCell"
    
    public let defaultName = "No name"
    public let defaultImage = UIImage(systemName: "questionmark.circle")!
    public let defaulrRoom = "No room"
    
    static var shared: configs = {
        let config = configs()
        return config
    }()
    
    private init() {}
}


extension configs: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
