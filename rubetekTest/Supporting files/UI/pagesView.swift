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

@IBDesignable
class pagesView : UIView {
    
    private let conf = configs.shared
    let DBag = DisposeBag()
    
    public private(set) var pages : [(page: menuPages, tableView : UITableView)] = []
    private let cameraData = PublishRelay<[cameraSectionModel]>()
    private let doorData = PublishRelay<[doorSectionModel]>()
    
    
    override func layoutSubviews() {
        preparingUI()
        preparingTableViewDict(completion: preparingTableViews)
        preparingStackView()
    }
    
    
    public func setCameraData(data : [cameraSectionModel]) {
        self.cameraData.accept(data)
    }
    
    public func setDoorsData(data : [doorSectionModel]) {
        self.doorData.accept(data)
    }
    
    
    
    private func preparingUI() {
        self.backgroundColor = .clear
    }
    
    private func preparingTableViews() {
        
        let camerasTableView = pages.first(where: {$0.page == .cameras})!.tableView
        self.preparingTableView(tableView: camerasTableView)
        camerasTableView.register(UINib(nibName: conf.cameraCellId, bundle: nil), forCellReuseIdentifier: conf.cameraCellId)
        let cameraDataSource = RxTableViewSectionedReloadDataSource<cameraSectionModel> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            return self.makeCameraCell(data: item, tableView: tableView)
        }
        
        cameraDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        cameraData
            .bind(to: camerasTableView.rx.items(dataSource: cameraDataSource))
            .disposed(by: DBag)
        
        
        
        let doorsTableView = pages.first(where: {$0.page == .doors})!.tableView
        self.preparingTableView(tableView: doorsTableView)
        doorsTableView.register(UINib(nibName: conf.doorCellId, bundle: nil), forCellReuseIdentifier: conf.doorCellId)
        doorsTableView.register(UINib(nibName: conf.cameraCellId, bundle: nil), forCellReuseIdentifier: conf.cameraCellId)
        let doorsDataSource = RxTableViewSectionedReloadDataSource<doorSectionModel> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            if item.snapshot != nil {
                return self.makeDoorCellWithImage(data: item, tableView: tableView)
            } else {
                return self.makeDoorCell(data: item, tableView: tableView)
            }
        }
        
        doorsDataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        doorData
            .bind(to: doorsTableView.rx.items(dataSource: doorsDataSource))
            .disposed(by: DBag)
    }
    
    private func makeCameraCell(data : cameraCellModel, tableView : UITableView) -> cameraCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: conf.cameraCellId) as! cameraCell
        cell.initFromCameraModel(data: data)
        return cell
    }
    
    private func makeDoorCellWithImage(data : doorCellModel, tableView : UITableView) -> cameraCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: conf.cameraCellId) as! cameraCell
        cell.initFromDoorModel(data: data)
        return cell
    }
    
    private func makeDoorCell(data : doorCellModel, tableView : UITableView) -> doorCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: conf.doorCellId) as! doorCell
        cell.initFromDoorModel(data: data)
        return cell
    }
    
    private func preparingTableView(tableView : UITableView) {
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: DBag)
        tableView.separatorStyle = .none
    }
    
    private func preparingStackView() {
        
        let stack = UIStackView(arrangedSubviews: pages.map({$0.tableView}))
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.frame = CGRect(x: .zero, y: .zero, width: self.frame.width, height: self.frame.height)
        self.addSubview(stack)
    }
    
    private func preparingTableViewDict(completion: @escaping() -> ()) {
        
        pages = []
        pages.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        menuPages.allCases.forEach { (page) in
            
            let tableView = UITableView()
            self.pages.append((page: page, tableView: tableView))
            tableView.backgroundColor = .clear
        }
        completion()
    }
}

extension pagesView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = self.setFavorite(tableView: tableView, indexPath: indexPath)

        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration 
    }
    
    private func setFavorite(tableView : UITableView, indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { action, view, completion in
            let cell = tableView.cellForRow(at: indexPath) as! customTableView
            guard let id = cell.id else { return }
            print(id)
        }
        action.image = UIImage(systemName: "star")
        action.backgroundColor = .clear
        return action
    }
    
}
//    square.and.pencil
//    star

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
//        headerView.backgroundColor = UIColor.red
//        return headerView
//    }

//extension pagesView: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 40)
//        let headerView = UIView(frame: frame)
//        headerView.backgroundColor = UIColor.clear
//
//        let titleLabel = UILabel(frame: frame)
//        headerView.addSubview(titleLabel)
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//}
