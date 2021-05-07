//
//  ColorSwatch.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 7.05.2021.
//

import Foundation
import UIKit

class ColorSwatch: UIView {
    
    private var color: UIColor
    typealias ColorSelected = (UIColor) -> Void
    
    private var colorSelected: ColorSelected
    
    init(color: UIColor, frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50), colorSelected: @escaping ColorSelected) {
        
        self.colorSelected = colorSelected
        self.color = color
        super.init(frame: frame)

        registerGestureRecognizers()
        
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        
        self.colorSelected(self.color)
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = self.color.cgColor
        self.layer.addSublayer(layer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
