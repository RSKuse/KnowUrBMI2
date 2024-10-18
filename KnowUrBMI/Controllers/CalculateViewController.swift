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
        //imageView.backgroundColor = .red
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
    
    lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CALCULATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(calculatePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var techButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CALCULATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4.0
        
        // Adding a gradient to the button
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.cornerRadius = 20
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        button.addTarget(self, action: #selector(calculatePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
   
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
        view.addSubview(calculateButton)
        view.addSubview(techButton)
        
    
        
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
        
        calculateButton.topAnchor.constraint(equalTo: weightSlider.bottomAnchor, constant: 40).isActive = true
        calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calculateButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        calculateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        techButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        techButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        techButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        techButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        resultVC.modalPresentationStyle = .fullScreen
        present(resultVC, animated: true, completion: nil)
    }
}
