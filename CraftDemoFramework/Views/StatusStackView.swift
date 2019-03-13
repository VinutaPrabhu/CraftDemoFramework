//
//  StatusStackView.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import Foundation

public class StatusStackView: UIStackView, UIPopoverPresentationControllerDelegate {
    var markerLabel: UILabel?
    var tagLabel: UILabel?
    var shapeLayer: CAShapeLayer?
    
    // To be fetched or calculated
    let rangeValues = ["0-199", "200-399", "400-599", "600-799", "800-1000"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        axis = .vertical
        distribution = .fillEqually
        spacing = 20
        translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkerLabel(notification:)), name: Notification.Name.SavingsInfoUpdated, object: nil)
        
        for i in 0..<SavingsCategory.allValues.count {
            let statusView = UIView(frame: frame)
            statusView.tag = SavingsCategory.allValues.count - 1 - i
            statusView.backgroundColor = SavingsCategory(rawValue: statusView.tag)?.color
            addArrangedSubview(statusView)
        }
        
        addLabels()
    }
    
    public func addLabels() {
        for statusView in arrangedSubviews {
            let label = UILabel(frame: CGRect(x: 25, y: -10, width: 200, height: 60))
            label.text = rangeValues[statusView.tag]
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            label.textAlignment = .left
            
            statusView.addSubview(label)
            statusView.bringSubviewToFront(label)
        }
    }
    
    @objc private func updateMarkerLabel(notification: Notification) {
        guard let category = notification.userInfo?[SavingsInfoService.categoryKey] as? SavingsCategory,
        let score = notification.userInfo?[SavingsInfoService.scoreKey] as? Float else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let statusView = self?.getStatusView(category) else { return }
            
            if let label = strongSelf.tagLabel {
                label.removeFromSuperview()
            }
            if let shapeLayer = self?.shapeLayer {
                shapeLayer.removeFromSuperlayer()
            }
            
            // Pointer shape
            let shapeLayer = strongSelf.getMarkerShapeLayer(statusView)
            statusView.layer.addSublayer(shapeLayer)
            self?.shapeLayer = shapeLayer
        
            // Score label
            let scoreLabel = strongSelf.getScoreLabel(statusView, score: "\(Int(score))")
            self?.tagLabel = scoreLabel
            statusView.addSubview(scoreLabel)
        }
    }
    
    private func getStatusView(_ category: SavingsCategory) -> UIView? {
        switch category.rawValue {
        case 0:
            return arrangedSubviews[4]
        case 1:
            return arrangedSubviews[3]
        case 2:
            return arrangedSubviews[2]
        case 3:
            return arrangedSubviews[1]
        case 4:
            return arrangedSubviews[0]
        default:
            return nil
        }
    }
    
    private func getMarkerShapeLayer(_ statusView: UIView) -> CAShapeLayer {
        let shapeLayer = MarkerShapeLayer(statusView.frame.width, statusView.frame.height, 25)
        return shapeLayer
    }
    
    private func getScoreLabel(_ statusView: UIView, score: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: statusView.center.x, y: 0, width: 120, height: statusView.frame.height) )
        label.text = score
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
    
        return label
    }
}

