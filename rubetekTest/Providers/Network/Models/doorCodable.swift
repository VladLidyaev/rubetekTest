//
//  doorCodable.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation

struct doorListCodable : Codable {
    let success : Bool?
    let data : [doorCodable]?
}

struct doorCodable : Codable {
    let name : String?
    let snapshot : String?
    let room : String?
    let id : Int
    let favorites : Bool?
}
