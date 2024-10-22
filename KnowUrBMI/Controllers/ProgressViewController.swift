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
    
    lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        return pieChart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updatePieChartData()
    }
    
    private func setupUI() {
        view.addSubview(pieChartView)
        
        pieChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pieChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pieChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    func updatePieChartData() {
        let entries = [
            PieChartDataEntry(value: Double(totalCaloriesBurned), label: "Calories Burned"),
            PieChartDataEntry(value: Double(7700 - totalCaloriesBurned), label: "Remaining to Lose 1kg")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
}
