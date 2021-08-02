//
//  homeViewController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit

class homeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkProvider.getDoors{ result in
            switch result {
            case .success(let articles):
                print("Success")
                print(articles)
            case .failure(let error):
                print("Failed")
                print(error.localizedDescription)
            }
        }
    }
}
