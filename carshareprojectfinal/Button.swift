//
//  Button.swift
//  
//
//  Created by 井上正裕 on 2017/03/04.
//
//

import UIKit



class Button: UIButton {

    private let tapEffectView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        // ボタン自体を角丸にする
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        // 円を描画
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.gray.cgColor
        shapeLayer.path = UIBezierPath(ovalIn: tapEffectView.bounds).cgPath
        tapEffectView.layer.addSublayer(shapeLayer)
        tapEffectView.isHidden = true
        
        addSubview(tapEffectView)
    }
    
    
    
}
