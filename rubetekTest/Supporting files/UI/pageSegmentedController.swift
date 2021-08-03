//
//  pageSegmentedController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit

@IBDesignable
class pageSegmentedController : UIControl {
    
    private let conf = configs.shared
    private var actualIndex : Int = 0
    private var buttons : [UIButton] = []
    private var selectorView = UIView()
    private let selectorViewHeight : CGFloat = 5
    
    override func layoutSubviews() {
        preparingButton()
        preparingSelectorView()
        preparingStackView()
    }
    
    private func preparingStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.frame = CGRect(x: .zero, y: .zero, width: self.frame.width, height: self.frame.height)
        self.addSubview(stack)
    }
    
    private func preparingSelectorView() {
        
        let backgroundSectionView = UIView(frame: CGRect(x: .zero, y: self.frame.height - selectorViewHeight, width: self.frame.width, height: selectorViewHeight))
        backgroundSectionView.backgroundColor = .gray
        self.addSubview(backgroundSectionView)
        
        let sectionWidth = self.frame.width / CGFloat(menuPages.allCases.count)
        selectorView = UIView(frame: CGRect(x: .zero, y: self.frame.height - selectorViewHeight, width: sectionWidth, height: selectorViewHeight))
        selectorView.layer.cornerRadius = selectorViewHeight/2
        selectorView.backgroundColor = .red
        self.addSubview(selectorView)
    }
    
    private func preparingButton() {
        
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        menuPages.allCases.forEach { (page) in
            let button = UIButton(type: .system)
            button.setTitle(page.rawValue, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            buttons.append(button)
        }
        buttons.first?.setTitleColor(.red, for: .normal)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for (buttonIndex, button) in buttons.enumerated() {
            button.setTitleColor(.black, for: .normal)
            if button == sender {
                
                let selectorPosition = self.frame.width / CGFloat(menuPages.allCases.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: conf.activeLineAnimationTime) {
                    
                    self.selectorView.frame.origin.x = selectorPosition
                    button.setTitleColor(.red, for: .normal)
                }
            }
        }
    }
}
