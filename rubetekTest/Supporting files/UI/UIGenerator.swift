//
//  UIGenerator.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation
import UIKit

class UIGenerator {
    
    static var shared: UIGenerator = {
            let generator = UIGenerator()
            return generator
        }()
    
    
    private init() {}
    
}


extension UIGenerator: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
