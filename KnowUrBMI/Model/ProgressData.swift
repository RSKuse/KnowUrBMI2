//
//  ProgressData.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/28.
//

import Foundation
import UIKit

struct ProgressData: Codable {
    let date: Date
    var caloriesBurned: Int
    var weight: Float
}
