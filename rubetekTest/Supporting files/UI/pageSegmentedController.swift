//
//  pageSegmentedController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit

@IBDesignable
class pageSegmentedController: UISegmentedControl {

    private var pageList : [menuPages] = []
    
    public func setMenu(_ pages: [menuPages]) {
        self.pageList = pages
    }
    
    private func preparingUI() {
        
    }
}
