//
//  cameraCell.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import UIKit

@IBDesignable
class cameraCell: customTableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var bottomIcon: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var starIcon: UIImageView!
    private let conf = configs.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preparingUI()
    }
    
    public func initFromCameraModel(data : cameraCellModel) {
        self.mainImageView.image = data.snapshot
        self.id = data.id
        self.titleLabel.text = data.name
        if !data.favorites {
            self.starIcon.alpha = 0
        } else {
            self.starIcon.alpha = 1
        }
    }
    
    public func initFromDoorModel(data : doorCellModel) {
        self.mainImageView.image = data.snapshot!
        self.id = data.id
        self.titleLabel.text = data.name
        if !data.favorites {
            self.starIcon.alpha = 0
        } else {
            self.starIcon.alpha = 1
        }
    }
    
    private func preparingUI() {
        
        self.selectionStyle = .none
        
        self.background.layer.cornerRadius = conf.cornerRadius
        self.mainImageView.layer.cornerRadius = conf.cornerRadius
        self.mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.background.layer.shadowColor = UIColor.black.cgColor
        self.background.layer.shadowOpacity = 0.1
        self.background.layer.shadowOffset = .zero
        self.background.layer.shadowRadius = conf.cornerRadius/6
        self.background.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
