//
//  models.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import Foundation

// DOORS

struct doorList : Codable {
    let success : Bool?
    let data : [door]?
}

struct door : Codable {
    let name : String?
    let snapshot : String?
    let room : String?
    let id : Int?
    let favorites : Bool?
}

// CAMERAS

struct camerasList : Codable {
    let success : Bool?
    let data : camerasInfo?
}

struct camerasInfo : Codable {
    let room : [String]?
    let cameras : [camera]?
}

struct camera : Codable {
    let name : String?
    let snapshot : String?
    let room : String?
    let id : Int?
    let favorites : Bool?
    let rec : Bool?
}
