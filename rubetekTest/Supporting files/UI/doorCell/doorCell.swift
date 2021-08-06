//
//  doorCell.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import UIKit

class doorCell: customTableView {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
    private let conf = configs.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        preparingUI()
    }
    
    public func initFromDoorModel(data : doorCellModel) {
        self.titleLabel.text = data.name
        self.id = data.id
        if !data.favorites {
            self.starIcon.alpha = 0
        } else {
            self.starIcon.alpha = 1
        }
    }
    
    private func preparingUI() {
        
        self.selectionStyle = .none
     
        self.background.layer.cornerRadius = conf.cornerRadius
        
        self.background.layer.shadowColor = UIColor.black.cgColor
        self.background.layer.shadowOpacity = 0.1
        self.background.layer.shadowOffset = .zero
        self.background.layer.shadowRadius = conf.cornerRadius/6
        self.background.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
