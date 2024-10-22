//
//  ProgressViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit
import DGCharts

class ProgressViewController: UIViewController {
    
    var bmiHistory: [Double] = [22.5, 21.8, 23.0, 22.0, 21.7]
    
    lazy var chartTypeSegmentedControl: UISegmentedControl = {
        let items = ["Line", "Bar", "Pie"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(chartTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    lazy var barChartView: BarChartView = {
        let barChart = BarChartView()
        barChart.isHidden = true
        barChart.translatesAutoresizingMaskIntoConstraints = false
        return barChart
    }()
    
    lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.isHidden = true
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        return pieChart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateLineChartData()
    }
    
    func setupUI() {
        view.addSubview(chartTypeSegmentedControl)
        view.addSubview(chartView)
        view.addSubview(barChartView)
        view.addSubview(pieChartView)
        
        chartTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        chartTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        chartView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.bottomAnchor, constant: 20).isActive = true
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        barChartView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.bottomAnchor, constant: 20).isActive = true
        barChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChartView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        barChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        pieChartView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.bottomAnchor, constant: 20).isActive = true
        pieChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChartView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        pieChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    @objc func chartTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView.isHidden = false
            barChartView.isHidden = true
            pieChartView.isHidden = true
            updateLineChartData()
        case 1:
            chartView.isHidden = true
            barChartView.isHidden = false
            pieChartView.isHidden = true
            updateBarChartData()
        case 2:
            chartView.isHidden = true
            barChartView.isHidden = true
            pieChartView.isHidden = false
            updatePieChartData()
        default:
            break
        }
    }
    
    func updateLineChartData() {
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
    
    func updateBarChartData() {
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, bmi) in bmiHistory.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: bmi)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "BMI Progress")
        chartDataSet.colors = [NSUIColor.systemGreen]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func updatePieChartData() {
        var dataEntries: [PieChartDataEntry] = []
        
        for bmi in bmiHistory {
            let dataEntry = PieChartDataEntry(value: bmi, label: String(format: "%.1f", bmi))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "BMI Distribution")
        chartDataSet.colors = [NSUIColor.systemPurple, NSUIColor.systemBlue, NSUIColor.systemGreen, NSUIColor.systemRed, NSUIColor.systemYellow]
        let chartData = PieChartData(dataSet: chartDataSet)
        pieChartView.data = chartData
    }
}
