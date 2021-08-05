//
//  cameraSectionModel.swift
//  rubetekTest
//
//  Created by Vlad on 05.08.2021.
//

import Foundation
import RxDataSources

struct cameraSectionModel {
    var header : String
    var items : [cameraCellModel]
}

extension cameraSectionModel : SectionModelType {
    
    typealias Item = cameraCellModel
    init(original: cameraSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
