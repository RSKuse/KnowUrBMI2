//
//  ProgressDataManager.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/29.
//

import Foundation
import UIKit

class ProgressDataManager {
    // Singleton instance for easy access
    static let shared = ProgressDataManager()
    
    private var progressData: [ProgressData] = []

    private init() {
        loadData() // Automatically load data on initialization
    }

    func addData(for date: Date, calories: Int, weight: Float) {
        if let index = progressData.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            // Update existing data for the day
            progressData[index].caloriesBurned += calories
            progressData[index].weight = weight
        } else {
            // Add new entry for the day
            progressData.append(ProgressData(date: date, caloriesBurned: calories, weight: weight))
        }
    }

    func getWeeklyData() -> [ProgressData] {
        // Retrieve the last 7 days' data
        return Array(progressData.suffix(7))
    }

    // MARK: - Persistence Methods
    func saveData() {
        if let data = try? JSONEncoder().encode(progressData) {
            UserDefaults.standard.set(data, forKey: "progressData")
        }
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "progressData"),
           let loadedData = try? JSONDecoder().decode([ProgressData].self, from: data) {
            progressData = loadedData
        }
    }
}
