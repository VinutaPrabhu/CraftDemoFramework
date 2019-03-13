//
//  SavingsCategory.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import UIKit

public enum SavingsCategory: Int {
    case Poor, Bad, Average, Good, Excellent
    
    public var color: UIColor {
        switch self {
        case .Poor:
            return UIColor(red: 192/255, green: 85/255, blue: 63/255, alpha: 1)
        case .Bad:
            return UIColor(red: 198/255, green: 102/255, blue: 64/255, alpha: 1)
        case .Average:
            return UIColor(red: 207/255, green: 141/255, blue: 80/255, alpha: 1)
        case .Good:
            return UIColor(red: 219/255, green: 185/255, blue: 95/255, alpha: 1)
        case .Excellent:
            return UIColor(red: 182/255, green: 205/255, blue: 125/255, alpha: 1)
        }
    }
    
    static var allValues: [SavingsCategory] {
        return [.Poor, .Bad, .Average, .Good, .Excellent]
    }
}
