//
//  configs.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation

enum menuPages : String {
    case cameras = "Камеры"
    case doors = "Двери"
}

class configs {
    
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
