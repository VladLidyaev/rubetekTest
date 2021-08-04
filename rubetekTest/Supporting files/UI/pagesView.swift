//
//  tableViewPage.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension room : SectionModelType {
    
    typealias Item = camera
    init(original: room, items: [Item]) {
        self = original
        self.items = items
    }
}

@IBDesignable
class pagesView : UIView {
    
    private let conf = configs.shared
    let DBag = DisposeBag()
    
    public private(set) var pages : [menuPages : UITableView] = [:]
    private let cameraData = PublishRelay<[room]>()
    private let doorData = BehaviorRelay(value: [String]())
    
    
    
    override func layoutSubviews() {
        preparingUI()
        preparingTableViewDict()
        preparingStackView()
    }
    
    
    
//    public func setData(forPage : menuPages, data: [room]) {
//        switch forPage {
//        case .cameras:
//            cameraData.accept(data)
//            break
//        case .doors:
//            doorData.accept(data)
//            break
//        }
//    }
    
    private func preparingUI() {
        self.backgroundColor = .clear
    }
    
    private func preparingTableViews() {
        
        guard pages[.cameras] != nil && pages[.doors] != nil else { return }
        
        
        let camerasTableView = pages[.cameras]!
//        camerasTableView.register(UINib(nibName: conf.cameraCellId, bundle: nil), forCellReuseIdentifier: conf.cameraCellId)
//
//        _ = cameraData.bind(to: camerasTableView.rx.items(cellIdentifier: conf.cameraCellId, cellType: cameraCell.self)) { (row,item,cell) in
//            cell.testLabel.text = item
//        }.disposed(by: DBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<room> { (dataSource, camerasTableView, indexPath, item) -> cameraCell in
            let cell = camerasTableView.dequeueReusableCell(withIdentifier: self.conf.cameraCellId) as! cameraCell
            cell.testLabel.text = item.name
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        cameraData
            .bind(to: camerasTableView.rx.items(dataSource: dataSource))
            .disposed(by: DBag)
        
        
        
        let doorsTableView = pages[.doors]!
        doorsTableView.register(UINib(nibName: conf.doorCellId, bundle: nil), forCellReuseIdentifier: conf.doorCellId)
        
        _ = doorData.bind(to: doorsTableView.rx.items(cellIdentifier: conf.doorCellId, cellType: doorCell.self)) { (row,item,cell) in
            cell.testLabel.text = item
        }.disposed(by: DBag)
    }
    
    private func preparingStackView() {
        
        let stack = UIStackView(arrangedSubviews: pages.values.map({$0}))
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.frame = CGRect(x: .zero, y: .zero, width: self.frame.width, height: self.frame.height)
        self.addSubview(stack)
    }
    
    private func preparingTableViewDict() {
        
        pages = [:]
        pages.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        menuPages.allCases.forEach { (page) in
            
            let tableView = UITableView()
            self.pages[page] = tableView
            tableView.backgroundColor = .clear
        }
        preparingTableViews()
    }
}
