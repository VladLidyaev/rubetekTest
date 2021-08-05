//
//  cameraCell.swift
//  rubetekTest
//
//  Created by Vlad on 04.08.2021.
//

import UIKit

@IBDesignable
class cameraCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var bottomIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func initFromModel(data : cameraCellModel) {
        self.mainImageView.image = data.snapshot
        self.titleLabel.text = data.name
    }
}
