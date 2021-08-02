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
    
    public let baseURL = "http://cars.cprogroup.ru/api/rubetek"
    
    static var shared: configs = {
            let config = configs()
            return config
        }()
    
    
    private init() {}
    
    public func start(vc : UIViewController) {
    }
}


extension configs: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
