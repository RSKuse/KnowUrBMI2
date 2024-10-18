//
//  ProgressViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit
import Charts
import DGCharts

class ProgressViewController: UIViewController {
    
    var bmiHistory: [Double] = [22.5, 21.8, 23.0, 22.0, 21.7] 
    
    lazy var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateChartData()
    }
    
    private func setupUI() {
        view.addSubview(chartView)
        
        // Layout constraints
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func updateChartData() {
        var dataEntries: [ChartDataEntry] = []
        
        for (index, bmi) in bmiHistory.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: bmi)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "BMI Progress")
        chartDataSet.colors = [NSUIColor.systemPurple]
        chartDataSet.circleColors = [NSUIColor.systemPurple]
        chartDataSet.circleRadius = 5.0
        chartDataSet.lineWidth = 2.0
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
}
