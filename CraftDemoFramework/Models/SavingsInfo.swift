//
//  SavingsInfo.swift
//  CraftDemoFramework
//
//  Created by Vinuta Prabhu on 13/03/19.
//  Copyright © 2019 Seven Lakes Enterprises. All rights reserved.
//

import Foundation

class SavingsInfo: NSObject, Codable {
    var expectedSavings: Float? = nil
    var currentSavings: Float? = nil
    var minSavings: Float? = nil
    var maxSavings: Float? = nil
    
    var rangeValues = [Int]()
    
    enum CodingKeys: String, CodingKey {
        case expectedSavings = "expectedSavings"
        case currentSavings = "currentSavings"
        case range = "range"
        case minSavings = "minSavings"
        case maxSavings = "maxSavings"
        case rangeValues = "rangeValues"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        expectedSavings = try values.decode(Float.self, forKey: .expectedSavings)
        currentSavings = try values.decode(Float.self, forKey: .currentSavings)
        minSavings = try values.decode(Float.self, forKey: .minSavings)
        maxSavings = try values.decode(Float.self, forKey: .maxSavings)
        
        let container = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .range)
        rangeValues = try container.decode([Int].self, forKey:.rangeValues)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(expectedSavings, forKey: .expectedSavings)
        try container.encode(currentSavings, forKey: .currentSavings)
        try container.encode(minSavings, forKey: .minSavings)
        try container.encode(maxSavings, forKey: .maxSavings)
        try container.encode(rangeValues, forKey: .rangeValues)
    }
}
