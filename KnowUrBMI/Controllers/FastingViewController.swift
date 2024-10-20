//
//  FastingViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit

class FastingViewController: UIViewController {

    var fastingDuration: Int = 3
    var userBMI: Float = 0.0
    
    lazy var fastingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Fasting Type"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fastingOptions: UISegmentedControl = {
        let items = ["Daniel Fast", "Dry Fast", "Wet Fast"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(fastingTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var fastingDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Fasting Days"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fastingDaysSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 3
        slider.maximumValue = 21
        slider.value = 3
        slider.addTarget(self, action: #selector(fastingDaysChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var fastingDaysValueLabel: UILabel = {
        let label = UILabel()
        label.text = "3 Days"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fastingDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "The Daniel Fast is a plant-based fast that is intended to lead to spiritual clarity and physical health."
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var startFastingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Fasting", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startFastingPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem = backButton
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(fastingTitleLabel)
        view.addSubview(fastingOptions)
        view.addSubview(fastingDaysLabel)
        view.addSubview(fastingDaysSlider)
        view.addSubview(fastingDaysValueLabel)
        view.addSubview(fastingDescriptionLabel)
        view.addSubview(startFastingButton)
        
        // Set constraints
        fastingTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        fastingTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fastingOptions.topAnchor.constraint(equalTo: fastingTitleLabel.bottomAnchor, constant: 20).isActive = true
        fastingOptions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastingOptions.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        fastingDaysLabel.topAnchor.constraint(equalTo: fastingOptions.bottomAnchor, constant: 20).isActive = true
        fastingDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        fastingDaysSlider.topAnchor.constraint(equalTo: fastingDaysLabel.bottomAnchor, constant: 20).isActive = true
        fastingDaysSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        fastingDaysSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        fastingDaysValueLabel.topAnchor.constraint(equalTo: fastingDaysSlider.bottomAnchor, constant: 10).isActive = true
        fastingDaysValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        fastingDescriptionLabel.topAnchor.constraint(equalTo: fastingDaysValueLabel.bottomAnchor, constant: 20).isActive = true
        fastingDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        fastingDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        startFastingButton.topAnchor.constraint(equalTo: fastingDescriptionLabel.bottomAnchor, constant: 40).isActive = true
        startFastingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startFastingButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startFastingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fastingTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fastingDescriptionLabel.text = "The Daniel Fast is a plant-based fast that is intended to lead to spiritual clarity and physical health."
        case 1:
            fastingDescriptionLabel.text = "Dry Fasting is an advanced form of fasting that involves no consumption of food or water for a set period."
        case 2:
            fastingDescriptionLabel.text = "Wet Fasting involves abstaining from solid food while consuming liquids such as water and tea."
        default:
            break
        }
    }
    
    @objc func fastingDaysChanged(_ sender: UISlider) {
        fastingDuration = Int(sender.value)
        fastingDaysValueLabel.text = "\(fastingDuration) Days"
    }
    
    @objc func startFastingPressed() {
        // Logic to track the user's fasting journey and calories lost
        let caloriesLost = calculateCaloriesLost(for: fastingDuration)
        
        let alertController = UIAlertController(title: "Fasting Complete!", message: "You have lost \(caloriesLost) calories in \(fastingDuration) days!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func calculateCaloriesLost(for days: Int) -> Int {
        if userBMI > 24.9 {
            return days * 300
        } else if userBMI < 18.5 {
            return days * 100
        } else {
            return days * 200 
        }
    }
}
