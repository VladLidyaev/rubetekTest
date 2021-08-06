//
//  homeViewController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class homeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageController: pageSegmentedController!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var customPagesView: pagesView!
    
    private let conf = configs.shared
    private let storage = storageProvider.shared
    private var showPages : [ menuPages : Bool ] = [:]
    private let baseQueue = DispatchQueue(label: "storageProvider.imageDownload", qos: .background, attributes: .concurrent)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparingUI()
        self.loadCameraPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addRefreshController()
    }
    
    private func preparingUI() {
        
        self.pageController.setBindingView(view: self.scrollView)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        menuPages.allCases.forEach { (page) in
            self.showPages[page] = false
        }
    }
    
    private func loadCameraPage(forceUpdate : Bool = false, completion: @escaping () -> Void = {return}) {
        baseQueue.async {
            self.storage.getCameraSection(update: forceUpdate) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.customPagesView.setCameraData(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    private func loadDoorPage(forceUpdate : Bool = false, completion: @escaping () -> Void = {return}) {
        baseQueue.async {
            self.storage.getDoorSection(update: forceUpdate) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.customPagesView.setDoorsData(data: data)
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.pageController.changePage(toPage: self.getActualPageIndex())
        self.uploadWhenShow(index: self.getActualPageIndex())
    }
    
    private func uploadWhenShow(index : Int) {
        switch index {
        case 0:
            if !showPages[.cameras]! {
                self.loadCameraPage()
                self.showPages[.cameras] = true
            }
        case 1:
            if !showPages[.doors]! {
                self.loadDoorPage()
                self.showPages[.doors] = true
            }
        default:
            break
        }
    }
    
    private func addRefreshController() {
        customPagesView.pages.map{ $0.tableView }.forEach { (tableView) in
            let refreshControl : UIRefreshControl = {
                let rc = UIRefreshControl()
                rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                return rc
            }()
            tableView.refreshControl = refreshControl
        }
    }
    
    private func getActualPageIndex() -> Int {
        return Int(round(scrollView.contentOffset.x/view.frame.width))
    }
    
    @objc private func refreshData(_ sender : UIRefreshControl) {
        
        let actualPage = conf.getPageByIndex(index: self.getActualPageIndex())
        switch actualPage {
        case .cameras:
            self.loadCameraPage(forceUpdate: true) {
                DispatchQueue.main.async {
                    sender.endRefreshing()
                }
            }
        case .doors:
            self.loadDoorPage(forceUpdate: true) {
                DispatchQueue.main.async {
                    sender.endRefreshing()
                }
            }
        default:
            break
        }
    }
}
