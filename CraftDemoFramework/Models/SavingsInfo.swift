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
    
    let minSavings: Float = 0.0
    let maxSavings: Float = 1000.0
    
    enum CodingKeys: String, CodingKey {
        case expectedSavings = "expectedSavings"
        case currentSavings = "currentSavings"
    }
    
    init(expectedSavings: Float, currentSavings: Float) {
        self.expectedSavings = expectedSavings
        self.currentSavings = currentSavings
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        expectedSavings = try values.decode(Float.self, forKey: .expectedSavings)
        currentSavings = try values.decode(Float.self, forKey: .currentSavings)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(expectedSavings, forKey: .expectedSavings)
        try container.encode(currentSavings, forKey: .currentSavings)
    }
}
