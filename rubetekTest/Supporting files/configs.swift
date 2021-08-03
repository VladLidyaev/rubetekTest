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
    public var activeLineAnimationTime : TimeInterval = 0.2
    
    
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
