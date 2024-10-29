//
//  ProgressViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import UIKit
import DGCharts

class ProgressViewController: UIViewController {
    
    var totalCaloriesBurned: Int = 0
    var weightData: [Double] = [] // Store weight data points
    var calorieBurnedData: [Double] = [] // Store daily or weekly calorie data points
    
    lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    lazy var achievementsLabel: UILabel = {
        let label = UILabel()
        label.text = "Achievements"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var insightsLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Summary & Insights"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateLineChartData()
        displayAchievements()
        displayWeeklyInsights()
    }
    
    private func setupUI() {
        view.addSubview(lineChartView)
        view.addSubview(achievementsLabel)
        view.addSubview(insightsLabel)
        
        // Layout constraints
        lineChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        lineChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        achievementsLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 20).isActive = true
        achievementsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        insightsLabel.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 10).isActive = true
        insightsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        insightsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func updateLineChartData() {
        let calorieEntries = calorieBurnedData.enumerated().map { (index, value) in
            return ChartDataEntry(x: Double(index), y: value)
        }
        
        let lineDataSet = LineChartDataSet(entries: calorieEntries, label: "Calories Burned")
        lineDataSet.colors = [UIColor.systemBlue]
        lineDataSet.circleColors = [UIColor.systemBlue]
        
        let data = LineChartData(dataSet: lineDataSet)
        lineChartView.data = data
    }
    
    private func displayAchievements() {
        var achievements = ""
        
        // Examples of achievements
        if totalCaloriesBurned > 500 {
            achievements += "🔥 500 Calories Burned\n"
        }
        if calorieBurnedData.count > 5 {
            achievements += "🏆 5 Consecutive Workouts\n"
        }
        if weightData.last ?? 0 < weightData.first ?? 0 {
            achievements += "📉 Weight Reduced!\n"
        }
        
        achievementsLabel.text = achievements.isEmpty ? "No achievements yet!" : achievements
    }
    
    private func displayWeeklyInsights() {
        let calorieTotal = calorieBurnedData.reduce(0, +)
        let averageCalories = calorieBurnedData.isEmpty ? 0 : calorieTotal / Double(calorieBurnedData.count)
        insightsLabel.text = "This week, you burned a total of \(Int(calorieTotal)) calories with an average of \(Int(averageCalories)) calories per day."
    }
}
