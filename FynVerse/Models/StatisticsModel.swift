//
//  StatisticsModel.swift
//  FynVerse
//
//  Created by zubair ahmed on 19/07/25.
//

import Foundation

struct StatisticsModel:Identifiable{
    let id = UUID().uuidString    
    let title:String
    let value:String
    let percentChange: Double
    
}
