//
//  homeViewController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

struct room {
    var header : String
    var items : [cameraCodable]
}

class homeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageController: pageSegmentedController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var customPagesView: pagesView!
    
    private let conf = configs.shared
    private let storage = storageProvider.shared
    private var showPages : [ menuPages : Bool ] = [:]
    private let baseQueue = DispatchQueue(label: "homeVC.update", qos: .utility, attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingUI()
//        self.loadCameraPage()
        storage.deleteCameraData { (_) in
            self.storage.deleteDoorData { (_) in
                self.loadCameraPage()
            }
        }
    }
    
    private func preparingUI() {
        
        self.pageController.setBindingView(view: self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        menuPages.allCases.forEach { (page) in
            guard page != .cameras else { return }
            self.showPages[page] = false
        }
    }
    
    private func loadCameraPage() {
        baseQueue.async {
            self.storage.getCameraSection { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.customPagesView.setCameraData(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadDoorPage() {
        baseQueue.async {
            self.storage.getDoorSection { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.customPagesView.setDoorsData(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        self.pageController.changePage(toPage: Int(pageIndex))
        
//        switch Int(pageIndex) {
//        case 1:
//            if !showPages[.doors]! {
//                self.loadDoorPage()
//            }
//        default:
//            break
//        }
    }
}
