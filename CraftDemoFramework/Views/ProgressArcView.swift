//
//  ProgressArcView.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import UIKit
public protocol ProgressArcViewProtocol {}

let placeHolderColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)

public class ProgressArcView: UIView, ProgressArcViewProtocol {
    let startAngle = CGFloat(90).inRadians()
    let endAngle = CGFloat(450).inRadians()
    var progressLayer = CAShapeLayer()
    var scoreLabel = UILabel()
    
    private var arcCenter: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    private var arcRadius: CGFloat {
        return frame.width / 3
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
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = percentange == 0 ? CGFloat(0.01) : CGFloat(percentange) // TODO: temporary to show slight color for 0
        progressLayer.strokeColor = strokeColor.cgColor
        
        scoreLabel.textColor = strokeColor
        scoreLabel.text = "\(Int(score))"
        CATransaction.commit()
    }
    
    private func addProgressView() {
        let placeholderLayer = getArcLayer(placeHolderColor)
        layer.addSublayer(placeholderLayer)
        
        progressLayer = getArcLayer(UIColor.white)
        layer.addSublayer(progressLayer)
        
        scoreLabel = getScoreLabel()
        addSubview(scoreLabel)
    }
    
    private func getArcLayer(_ strokeColor: UIColor) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: arcRadius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        let progressLayer = CAShapeLayer()
        progressLayer.lineWidth = 15
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = strokeColor.cgColor
        progressLayer.fillColor = UIColor.white.cgColor
        
        return progressLayer
    }
    
    private func getScoreLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: arcCenter.x, y: arcCenter.y, width: arcRadius, height: arcRadius / 2))
        label.center = arcCenter
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 45.0)
        label.textColor = UIColor.black
        
        return label
    }
}

extension CGFloat {
    func inRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

