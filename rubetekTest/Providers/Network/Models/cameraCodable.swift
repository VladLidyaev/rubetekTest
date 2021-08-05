//
//  cameraCodable.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import Foundation

struct camerasListCodable : Codable {
    let success : Bool?
    let data : camerasInfoCodable?
}

struct camerasInfoCodable : Codable {
    let room : [String]?
    let cameras : [cameraCodable]?
}

struct cameraCodable : Codable {
    let name : String?
    let snapshot : String?
    let room : String?
    let id : Int
    let favorites : Bool?
    let rec : Bool?
}
