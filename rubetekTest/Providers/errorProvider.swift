//
//  errorProvider.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation

class errorProvider {
    
    static var shared: errorProvider = {
            let provider = errorProvider()
            return provider
        }()
    
    
    private init() {}
}


extension errorProvider: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
