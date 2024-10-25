//
//  ViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/09/16.
//

import Foundation
import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()
    

    lazy var calculatorBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "calculate_background")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CALCULATE YOUR BMI"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1.5m"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 2.5
        slider.value = 1.5
        slider.addTarget(self, action: #selector(heightSliderChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "100Kg"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 30
        slider.maximumValue = 200
        slider.value = 100
        slider.addTarget(self, action: #selector(weightSliderChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        setupButtons()
   
    }
    
    func setupUI() {
        view.addSubview(calculatorBackgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(heightLabel)
        view.addSubview(heightValueLabel)
        view.addSubview(heightSlider)
        view.addSubview(weightLabel)
        view.addSubview(weightValueLabel)
        view.addSubview(weightSlider)
    
        
        calculatorBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        calculatorBackgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calculatorBackgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calculatorBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        heightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        heightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        heightValueLabel.centerYAnchor.constraint(equalTo: heightLabel.centerYAnchor).isActive = true
        heightValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        heightSlider.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 20).isActive = true
        heightSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        heightSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        weightLabel.topAnchor.constraint(equalTo: heightSlider.bottomAnchor, constant: 40).isActive = true
        weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        weightValueLabel.centerYAnchor.constraint(equalTo: weightLabel.centerYAnchor).isActive = true
        weightValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        weightSlider.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20).isActive = true
        weightSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        weightSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

    }
    

    
    func setupButtons() {
        let buttonData = [
            (title: "CALCULATE", color: UIColor.systemPurple, action: #selector(calculatePressed)),
            (title: "RESET", color: UIColor.systemRed, action: #selector(resetPressed))
        ]
        
        ButtonFacade.createButtonsAndLayout(in: view, buttonData: buttonData, target: self)

    }
    
    @objc func heightSliderChanged(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightValueLabel.text = "\(height)m"
    }
    
    @objc func weightSliderChanged(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        weightValueLabel.text = "\(weight)Kg"
    }
    
    @objc func calculatePressed() {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        calculatorBrain.calculateBMI(height: height, weight: weight)
        
        let resultVC = ResultViewController()
        resultVC.bmiValue = calculatorBrain.getBMIValue()
        resultVC.advice = calculatorBrain.getAdvice()
        resultVC.color = calculatorBrain.getColor()
        
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @objc func resetPressed() {
        heightSlider.value = 1.5
        weightSlider.value = 100
    }
}
