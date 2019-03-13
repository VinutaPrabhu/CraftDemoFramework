//
//  MarkerShapeLayer.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import Foundation

class MarkerShapeLayer: CAShapeLayer {
    
    convenience init(_ width: CGFloat, _ height: CGFloat, _ pointerWidth: CGFloat) {
        self.init()
        configureShapeLayer(width, height, pointerWidth)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureShapeLayer(_ width: CGFloat, _ height: CGFloat, _ pointerWidth: CGFloat) {
        path = getMarkerPath(width, height, pointerWidth).cgPath
        strokeColor = UIColor.white.cgColor
        fillColor = UIColor.white.cgColor
        borderColor = UIColor.blue.cgColor
        position = CGPoint(x: width / 2, y: 0)
        addShadow(self)
    }
    
    private func getMarkerPath(_ width: CGFloat, _ height: CGFloat, _ pointerWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: pointerWidth, y: 0))
        path.addLine(to: CGPoint(x: width / 4, y: 0))
        path.addLine(to: CGPoint(x: width / 4, y: height))
        path.addLine(to: CGPoint(x: pointerWidth, y: height))
        path.close()
        
        return path
    }
    
    private func addShadow(_ shapeLayer: CAShapeLayer) {
        shapeLayer.shadowOffset = CGSize(width: 10, height: 10)
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.7
        shapeLayer.shadowRadius = 5.0
    }
}
