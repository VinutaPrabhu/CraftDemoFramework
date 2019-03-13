//
//  SavingsInfoService.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var SavingsInfoUpdated: NSNotification.Name {
        return NSNotification.Name(rawValue: "SavingsInfoUpdated")
    }
}

public protocol SavingsInfoServiceProtocol {
    static var sharedInstance: SavingsInfoService! { get }
    
    func savingsInfoDidUpdate(_ data: Data)
}

protocol SavingsInfoServicePrivateProtocol {
    func getSavingsCategory() -> SavingsCategory?
    func rangeLabel(_ index: Int) -> String
    func getSavingsPercentage() -> Float?
}

public class SavingsInfoService: NSObject, SavingsInfoServiceProtocol, SavingsInfoServicePrivateProtocol {
    static let percentageKey = "percentage"
    static let categoryKey = "category"
    static let colorKey = "color"
    static let scoreKey = "score"
    
    private static var instance = SavingsInfoService()
    private var savingsInfo: SavingsInfo?
    private var updateTimer: Timer!
    
    public static var sharedInstance: SavingsInfoService! {
        return instance
    }
    
    override init() {
        super.init()
    }
    
    public func savingsInfoDidUpdate(_ data: Data) {
        guard let savingsInfo = try? JSONDecoder().decode(SavingsInfo.self, from: data) else { return }
        
        self.savingsInfo = savingsInfo
        
        var userInfo = [String: Any]()
        userInfo[SavingsInfoService.percentageKey] = getSavingsPercentage()
        userInfo[SavingsInfoService.colorKey] = getSavingsCategory()?.color
        userInfo[SavingsInfoService.categoryKey] = getSavingsCategory()
        userInfo[SavingsInfoService.scoreKey] = getSavingsScore()
        
        NotificationCenter.default.post(name: .SavingsInfoUpdated, object: nil, userInfo: userInfo)
    }
    
    // MARK: Find savings category
    
    func getSavingsCategory() -> SavingsCategory? {
        guard let score = getSavingsScore(), let maxSavings = savingsInfo?.maxSavings else { return nil }
        
        var category = score * Float(SavingsCategory.allValues.count) / maxSavings
        if maxSavings == score {
            category = Float(SavingsCategory.allValues.count) - 1
        }
        
        return SavingsCategory(rawValue: Int(category)) ?? nil
    }
    
    func rangeLabel(_ index: Int) -> String {
        guard let maxSavings = savingsInfo?.maxSavings else { return "" }
        let increment = maxSavings / Float(SavingsCategory.allValues.count)
        let start = Float(index) * increment
        let end = start + increment - 1
        
        return "\(start)-\(end)"
    }
    
    func getSavingsPercentage() -> Float? {
        guard let currentSavings = savingsInfo?.currentSavings, let expectedSavings = savingsInfo?.expectedSavings else { return nil }
        if currentSavings > expectedSavings { return 1 }
        if currentSavings <= 0 { return 0 }
        
        return Float(Float(currentSavings) / Float(expectedSavings))
    }
    
    // MARK: Private functions
    
    private func getSavingsScore() -> Float? {
        guard let currentSavings = savingsInfo?.currentSavings, let expectedSavings = savingsInfo?.expectedSavings, let maxSavings = savingsInfo?.maxSavings else { return nil }
        if currentSavings > expectedSavings { return savingsInfo?.maxSavings }
        if currentSavings <= 0 { return savingsInfo?.minSavings }
        
        return currentSavings * maxSavings / expectedSavings
    }
    
}

