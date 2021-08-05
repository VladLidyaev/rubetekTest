//
//  pageSegmentedController.swift
//  rubetekTest
//
//  Created by Vlad on 02.08.2021.
//

import UIKit

@IBDesignable
class pageSegmentedController : UIControl {
    
    private var conf = configs.shared
    private var selectorView = UIView()
    private var bindingView : UIScrollView? = nil
    private var swipeIsEnable : Bool = false
    
    public private(set) var actualIndex : Int = 0
    
    public private(set) var buttons : [UIButton] = []
    
    @IBInspectable var selectorHeight: CGFloat = 3 {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var selectorColor: UIColor = .blue {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var textColor: UIColor = .black {
        didSet { self.layoutSubviews() }
    }
    
    @IBInspectable var pageTitleFontSize: CGFloat = 10 {
        didSet { self.layoutSubviews() }
    }
    
    
    
    override func layoutSubviews() {
        preparingButton()
        preparingSelectorView()
        preparingStackView()
    }
    
    
    public func setBindingView(view : UIScrollView) {
        
        self.bindingView = view
    }
    
    public func changePage(toPage: Int) {
        
        guard !swipeIsEnable else { return }
        guard 0 <= toPage && toPage <= buttons.count-1 else { return }
        let newButton = buttons[toPage]
        
        for (buttonIndex, button) in self.buttons.enumerated() {
            if actualIndex != buttonIndex && button == newButton {
                
                self.actualIndex = buttonIndex
                
                let selectorPosition = self.frame.width / CGFloat(menuPages.allCases.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: TimeInterval(conf.selectorAnimationTime)) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
            }
        }
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
        
        let backgroundSectionLayer = CAGradientLayer()
        backgroundSectionLayer.frame = CGRect(x: .zero, y: self.frame.height - selectorHeight, width: self.frame.width, height: selectorHeight)
        backgroundSectionLayer.colors = [UIColor.black.withAlphaComponent(0.05).cgColor, UIColor.clear.cgColor]
        self.layer.addSublayer(backgroundSectionLayer)
        
        let sectionWidth = self.frame.width / CGFloat(menuPages.allCases.count)
        selectorView = UIView(frame: CGRect(x: CGFloat(self.actualIndex)*sectionWidth, y: self.frame.height - selectorHeight, width: sectionWidth, height: selectorHeight))
        selectorView.layer.cornerRadius = selectorHeight/2
        selectorView.backgroundColor = self.selectorColor
        self.addSubview(selectorView)
    }
    
    private func preparingButton() {
        
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        menuPages.allCases.forEach { (page) in
            let button = UIButton(type: .custom)
            button.setTitle(page.rawValue, for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(pageTitleFontSize)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.setTitleColor(self.textColor, for: .normal)
            buttons.append(button)
        }
    }
    
    private func changeBindingView(newIndex : Int) {
        
        guard bindingView != nil else { return }
        self.bindingView!.setContentOffset(CGPoint(x: CGFloat(newIndex)*UIScreen.main.bounds.width, y: .zero), animated: true)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {

        for (buttonIndex, button) in self.buttons.enumerated() {
            if actualIndex != buttonIndex && button == sender {
                
                self.swipeIsEnable = true
                self.actualIndex = buttonIndex
                self.changeBindingView(newIndex: buttonIndex)
                
                let selectorPosition = self.frame.width / CGFloat(menuPages.allCases.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: TimeInterval(conf.selectorAnimationTime)) {
                    self.selectorView.frame.origin.x = selectorPosition
                } completion: { (_) in
                    self.swipeIsEnable = false
                }
            }
        }
    }
}
