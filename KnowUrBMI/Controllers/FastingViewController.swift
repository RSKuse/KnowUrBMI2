//
//  FastingViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit


class FastingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var fastingDuration: Int = 1 // Default day 1
    var userBMI: Float = 0.0
    var fastingTimer: Timer?
    var fastingDurationRemaining: Int = 0 // Will be calculated based on selected days
    var isFastingActive = false
    
    // Array of Bible verses about fasting with their explanations
    let fastingVerses = [
        ("Matthew 6:16", "When you fast, do not look somber as the hypocrites do, for they disfigure their faces to show others they are fasting.", "This verse teaches us to fast humbly and for spiritual purposes, not to seek admiration from others."),
        ("Isaiah 58:6", "Is not this the kind of fasting I have chosen: to loose the chains of injustice?", "This verse emphasizes fasting as a way to fight against injustice and oppression."),
        ("Joel 2:12", "Return to me with all your heart, with fasting and weeping and mourning.", "Fasting is a form of repentance and drawing closer to God."),
        ("Luke 4:2", "For forty days he was tempted by the devil. He ate nothing during those days.", "Jesus fasted for strength and spiritual clarity during his trials."),
        ("Psalm 35:13", "I humbled my soul with fasting; And my prayer kept returning to me.", "Fasting helps to humble the soul and strengthen prayers.")
    ]
    
    // UI Elements
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
    
    // Label to trigger picker view
    lazy var chooseDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Days"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDayPicker))
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Picker for selecting fasting days (initially hidden)
    lazy var dayPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self // Set dataSource
        picker.delegate = self // Set delegate
        picker.isHidden = true // Hidden initially
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // Dynamic Verse Label (hidden initially)
    lazy var verseLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Empty initially
        label.font = UIFont(name: "Chalkboard SE", size: 18)// Cartoonish font
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true // Hidden initially
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Verse Explanation Label (hidden initially)
    lazy var verseExplanationLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Empty initially
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true // Hidden initially
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Progress Slider for tracking fasting days
    lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 31
        slider.value = 1
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isUserInteractionEnabled = true // To prevent manual changes
        return slider
    }()
    
    // Fasting Button
    lazy var fastingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Fasting", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(fastingButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(fastingTitleLabel)
        view.addSubview(fastingOptions)
        view.addSubview(chooseDaysLabel)
        view.addSubview(dayPicker)
        view.addSubview(progressSlider)
        view.addSubview(verseLabel)
        view.addSubview(verseExplanationLabel)
        view.addSubview(fastingButton)
        
        // Set constraints
        fastingTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        fastingTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fastingOptions.topAnchor.constraint(equalTo: fastingTitleLabel.bottomAnchor, constant: 20).isActive = true
        fastingOptions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastingOptions.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        chooseDaysLabel.topAnchor.constraint(equalTo: fastingOptions.bottomAnchor, constant: 20).isActive = true
        chooseDaysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dayPicker.topAnchor.constraint(equalTo: chooseDaysLabel.bottomAnchor, constant: 10).isActive = true
        dayPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        progressSlider.topAnchor.constraint(equalTo: dayPicker.bottomAnchor, constant: 20).isActive = true
        progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        verseLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 20).isActive = true
        verseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        verseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        verseExplanationLabel.topAnchor.constraint(equalTo: verseLabel.bottomAnchor, constant: 10).isActive = true
        verseExplanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        verseExplanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        fastingButton.topAnchor.constraint(equalTo: verseExplanationLabel.bottomAnchor, constant: 40).isActive = true
        fastingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastingButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        fastingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func showDayPicker() {
        // Show the picker view when label is tapped
        dayPicker.isHidden = false
        verseLabel.isHidden = true
        verseExplanationLabel.isHidden = true
    }
    
    @objc func fastingButtonPressed() {
        if isFastingActive {
            stopFasting()
        } else {
            startFasting()
        }
    }
    
    func startFasting() {
        isFastingActive = true
        fastingDurationRemaining = fastingDuration * 86400 // Convert days to seconds
        fastingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateFastingTimer), userInfo: nil, repeats: true)
        
        // Hide picker and show verse and explanation
        dayPicker.isHidden = true
        let randomVerse = getRandomVerse()
        let fullVerse = "\(randomVerse.0): \(randomVerse.1)"
        let verseExplanation = randomVerse.2
        
        verseLabel.text = fullVerse
        verseExplanationLabel.text = verseExplanation
        
        verseLabel.isHidden = false
        verseExplanationLabel.isHidden = false
        
        // Update button to "Stop Fasting"
        fastingButton.setTitle("Stop Fasting", for: .normal)
        fastingButton.backgroundColor = .red
    }
    
    func stopFasting() {
        isFastingActive = false
        fastingTimer?.invalidate()
        fastingTimer = nil
        
        // Hide verse and reset UI
        verseLabel.isHidden = true
        verseExplanationLabel.isHidden = true
        fastingButton.setTitle("Start Fasting", for: .normal)
        fastingButton.backgroundColor = .systemGreen
        
        // Reset the progress
        progressSlider.value = 1
        chooseDaysLabel.text = "Choose Your Days"
    }
    
    
    func confirmStopFasting() {
        let alertController = UIAlertController(title: "Stop Fasting?", message: "Are you sure you want to stop fasting?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.stopFasting()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateFastingTimer() {
        if fastingDurationRemaining > 0 {
            fastingDurationRemaining -= 1
            let hours = fastingDurationRemaining / 3600
            let daysRemaining = hours / 24
            progressSlider.value = Float(fastingDurationRemaining) / Float(fastingDuration * 86400)
            
            // Update days remaining
            chooseDaysLabel.text = "\(daysRemaining) days remaining"
        } else {
            stopFasting()
            showFastingResult()
        }
    }
    
    func showFastingResult() {
        let caloriesLost = calculateCaloriesLost(for: fastingDuration)
        
        let alertController = UIAlertController(title: "Fasting Complete!", message: "You have fasted for \(fastingDuration) days and lost \(caloriesLost) calories!", preferredStyle: .alert)
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

    
    // Function to get a random verse and explanation
    func getRandomVerse() -> (String, String, String) {
        return fastingVerses.randomElement() ?? ("No Verse", "No Explanation", "No Explanation")
    }
    
    
    
    
    @objc func fastingTypeChanged(_ sender: UISegmentedControl) {
        var fastingTypeExplanation = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            fastingTypeExplanation = "You have chosen Daniel Fast. A plant-based fast intended for spiritual clarity and physical health. Meals: fruits, vegetables, nuts."
        case 1:
            fastingTypeExplanation = "You have chosen Dry Fast. A more intense fast with no food or water. Be mindful of your health."
        case 2:
            fastingTypeExplanation = "You have chosen Wet Fast. Abstaining from solid food but liquids are allowed, such as water and herbal teas."
        default:
            break
        }
        
        let alertController = UIAlertController(title: "Fasting Type", message: fastingTypeExplanation, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Only 1 component for days
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 31 // Allow selection of 1 to 31 days
    }
    
    // MARK: UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) Days"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fastingDuration = row + 1 // Update the fasting duration
        chooseDaysLabel.text = "Selected: \(fastingDuration) Days"
    }
}
