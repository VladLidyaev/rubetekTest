//
//  homeViewController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit

struct room {
    var header : String
    var items : [camera]
}

class homeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageController: pageSegmentedController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var customPagesView: pagesView!
    
    private let conf = configs.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingUI()
        
        let sp = storageProvider()
        sp.setData()
    }
    
    
    
    private func preparingUI() {
        
        self.pageController.setBindingView(view: self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        self.pageController.changePage(toPage: Int(pageIndex))
    }
}
