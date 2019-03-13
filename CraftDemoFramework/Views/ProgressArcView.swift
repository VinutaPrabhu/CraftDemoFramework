//
//  ProgressArcView.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import UIKit

public protocol ProgressArcViewProtocol {}

public class ProgressArcView: UIView, ProgressArcViewProtocol {
    let startAngle = CGFloat(90).inRadians()
    let endAngle = CGFloat(450).inRadians()
    let arcLayer = CAShapeLayer()
    let scoreLabel = UILabel()
    
    private var arcCenter: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    private var arcRadius: CGFloat {
        return frame.width / 3
    }
    
    convenience init(_ frame: CGRect) {
        self.init(frame: frame)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: Private UI configuration functions
    
    private func configure() {
        backgroundColor = UIColor.white
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressArc(notification:)), name: Notification.Name.SavingsInfoUpdated, object: nil)
    
        addProgressView()
    }
    
    @objc private func updateProgressArc(notification: Notification) {
        guard let percentage = notification.userInfo?[SavingsInfoService.percentageKey] as? Float,
            let color = notification.userInfo?[SavingsInfoService.colorKey] as? UIColor,
            let score = notification.userInfo?[SavingsInfoService.scoreKey] as? Float else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.updateProgressArc(with: percentage, color, score)
        }
    }
    
    private func updateProgressArc(with percentange: Float, _ strokeColor: UIColor, _ score: Float) {
        CATransaction.begin()
        arcLayer.strokeStart = 0
        arcLayer.strokeEnd = CGFloat(percentange)
        arcLayer.strokeColor = strokeColor.cgColor
        scoreLabel.textColor = strokeColor
        scoreLabel.text = "\(Int(score))"
        CATransaction.commit()
    }
    
    private func addProgressView() {
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: arcRadius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        arcLayer.lineWidth = 15
        arcLayer.path = path.cgPath
        arcLayer.strokeColor = UIColor.white.cgColor
        arcLayer.fillColor = UIColor.white.cgColor
        arcLayer.strokeStart = 0
        arcLayer.strokeEnd = 0.5
        
        scoreLabel.frame = CGRect(x: arcCenter.x, y: arcCenter.y, width: arcRadius, height: arcRadius / 2)
        scoreLabel.center = arcCenter
        scoreLabel.text = ""
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 45.0)
        scoreLabel.textColor = UIColor.black
        
        layer.addSublayer(arcLayer)
        addSubview(scoreLabel)
    }
}

extension CGFloat {
    func inRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

