//
//  doorSectionModel.swift
//  rubetekTest
//
//  Created by Vlad on 05.08.2021.
//

import Foundation
import RxDataSources

struct doorSectionModel {
    var header : String
    var items : [doorCellModel]
}

extension doorSectionModel : SectionModelType {
    
    typealias Item = doorCellModel
    init(original: doorSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
