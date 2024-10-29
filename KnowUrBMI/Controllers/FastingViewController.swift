//
//  FastingViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit


class FastingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var fastingDuration: Int = 1
    var userBMI: Float = 0.0
    var fastingTimer: Timer?
    var fastingDurationRemaining: Int = 0
    var isFastingActive = false
    var fastingDays: Int = 0
    var fastingHours: Int = 0
    var fastingMinutes: Int = 0
    var fastingTypeSelected = false
    var fastingDurationSelected = false
    
    var healthTipTimer: Timer?
    var currentTipIndex = 0
    
    var fastingButton: UIButton?
    
    let fastingVerses = [
        ("Matthew 6:16", "When you fast, do not look somber as the hypocrites do, for they disfigure their faces to show others they are fasting.", "This verse teaches us to fast humbly and for spiritual purposes, not to seek admiration from others."),
        ("Isaiah 58:6", "Is not this the kind of fasting I have chosen: to loose the chains of injustice?", "This verse emphasizes fasting as a way to fight against injustice and oppression."),
        ("Joel 2:12", "Return to me with all your heart, with fasting and weeping and mourning.", "Fasting is a form of repentance and drawing closer to God."),
        ("Luke 4:2", "For forty days he was tempted by the devil. He ate nothing during those days.", "Jesus fasted for strength and spiritual clarity during his trials."),
        ("Psalm 35:13", "I humbled my soul with fasting; And my prayer kept returning to me.", "Fasting helps to humble the soul and strengthen prayers.")
    ]
    
    let healthTips = [
        "Remember to stay hydrated during fasting!",
        "Fasting helps detoxify your body and gives rest to your digestive system.",
        "Taking short walks can help during fasting and keep your mind refreshed.",
        "Fasting can enhance mental clarity and focus.",
        "Remember to break your fast slowly to avoid digestive discomfort."
    ]
    
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
        segmentedControl.selectedSegmentIndex = -1
        segmentedControl.addTarget(self, action: #selector(fastingTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
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
    
    lazy var dayPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var verseLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Chalkboard SE", size: 18)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var verseExplanationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countdownTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00:00"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .systemPurple
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    lazy var healthTipLabel: UILabel = {
        let label = UILabel()
        label.text = healthTips[0]
        label.font = UIFont(name: "Chalkboard SE", size: 20)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtonFacade()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(fastingTitleLabel)
        view.addSubview(fastingOptions)
        view.addSubview(chooseDaysLabel)
        view.addSubview(dayPicker)
        view.addSubview(verseLabel)
        view.addSubview(verseExplanationLabel)
        view.addSubview(countdownTimerLabel)
        view.addSubview(healthTipLabel)
        
        fastingTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        fastingTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fastingOptions.topAnchor.constraint(equalTo: fastingTitleLabel.bottomAnchor, constant: 20).isActive = true
        fastingOptions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastingOptions.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        chooseDaysLabel.topAnchor.constraint(equalTo: fastingOptions.bottomAnchor, constant: 20).isActive = true
        chooseDaysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dayPicker.topAnchor.constraint(equalTo: chooseDaysLabel.bottomAnchor, constant: 10).isActive = true
        dayPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        countdownTimerLabel.topAnchor.constraint(equalTo: dayPicker.bottomAnchor, constant: 20).isActive = true
        countdownTimerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        countdownTimerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        verseLabel.topAnchor.constraint(equalTo: countdownTimerLabel.bottomAnchor, constant: 20).isActive = true
        verseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        verseLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        verseExplanationLabel.topAnchor.constraint(equalTo: verseLabel.bottomAnchor, constant: 10).isActive = true
        verseExplanationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        verseExplanationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        healthTipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        healthTipLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        healthTipLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        healthTipLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    
    private func setupButtonFacade() {
        let buttonData = ButtonData(
            title: "Start Fasting",
            color: .systemGreen,
            action: #selector(fastingButtonPressed),
            isEnabled: true
        )

        let buttons = ButtonFacade.createButtons([buttonData], target: self)
        ButtonFacade.layoutButtons(buttons, in: view, position: .bottom)
        fastingButton = buttons.first
    }
    
    private func updateFastingButtonState(isFastingActive: Bool) {
        let title = isFastingActive ? "Stop Fasting" : "Start Fasting"
        let color = isFastingActive ? UIColor.red : UIColor.systemGreen

        fastingButton?.setTitle(title, for: .normal)
        fastingButton?.backgroundColor = color
    }
    
    
    @objc func showDayPicker() {
        dayPicker.isHidden = false
        verseLabel.isHidden = true
        verseExplanationLabel.isHidden = true
        countdownTimerLabel.isHidden = true
        healthTipLabel.isHidden = true
        
    }
    
    @objc func fastingButtonPressed() {
        if !fastingTypeSelected || !fastingDurationSelected {
            let alertController = UIAlertController(
                title: "Missing Selections",
                message: "Please select a fasting type and duration before starting.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            if isFastingActive {
                confirmStopFasting()
            } else {
                startFasting()
            }
        }
    }
    
    func startFasting() {
        isFastingActive = true
        updateFastingButtonState(isFastingActive: true)
        fastingDurationRemaining = (fastingDays * 86400) + (fastingHours * 3600) + (fastingMinutes * 60)
        fastingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateFastingTimer), userInfo: nil, repeats: true)

        // Show the verse and timer
        dayPicker.isHidden = true
        let randomVerse = getRandomVerse()
        verseLabel.text = "\(randomVerse.0): \(randomVerse.1)"
        verseExplanationLabel.text = randomVerse.2
        verseLabel.isHidden = false
        verseExplanationLabel.isHidden = false
        countdownTimerLabel.isHidden = false


        healthTipLabel.isHidden = false
        startHealthTipAnimation()
    }

    func stopFasting() {
        isFastingActive = false
        updateFastingButtonState(isFastingActive: false)
        fastingTimer?.invalidate()
        fastingTimer = nil


        verseLabel.isHidden = true
        verseExplanationLabel.isHidden = true
        countdownTimerLabel.isHidden = true
        healthTipLabel.isHidden = true
        stopHealthTipAnimation()
       
        let currentWeight = Float(69.8) // Update weight data if available
        ProgressDataManager.shared.addData(for: Date(), calories: 0, weight: currentWeight)
        ProgressDataManager.shared.saveData() // Save after updating
        
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
            let days = fastingDurationRemaining / 86400
            let hours = (fastingDurationRemaining % 86400) / 3600
            let minutes = (fastingDurationRemaining % 3600) / 60
            let seconds = fastingDurationRemaining % 60
            countdownTimerLabel.text = String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
        } else {
            stopFasting()
            showFastingResult()
        }
    }
    
    func showFastingResult() {
        let totalSeconds = (fastingDays * 86400) + (fastingHours * 3600) + (fastingMinutes * 60)
        let elapsedTime = totalSeconds - fastingDurationRemaining
        
        let days = elapsedTime / 86400
        let hours = (elapsedTime % 86400) / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        
        var fastingDurationString = ""
        
        if days > 0 {
            fastingDurationString += "\(days) day\(days > 1 ? "s" : "")"
        }
        if hours > 0 {
            if !fastingDurationString.isEmpty { fastingDurationString += ", " }
            fastingDurationString += "\(hours) hour\(hours > 1 ? "s" : "")"
        }
        if minutes > 0 {
            if !fastingDurationString.isEmpty { fastingDurationString += ", " }
            fastingDurationString += "\(minutes) minute\(minutes > 1 ? "s" : "")"
        }
        if seconds > 0 {
            if !fastingDurationString.isEmpty { fastingDurationString += ", " }
            fastingDurationString += "\(seconds) second\(seconds > 1 ? "s" : "")"
        }
        
        if fastingDurationString.isEmpty {
            fastingDurationString = "0 minutes"
        }
        
        let caloriesLost = calculateCaloriesLost(for: fastingDays)
        
        let alertController = UIAlertController(
            title: "Fasting Complete!",
            message: "You have fasted for \(fastingDurationString) and lost \(caloriesLost) calories!",
            preferredStyle: .alert
        )
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
    
    func getRandomVerse() -> (String, String, String) {
        return fastingVerses.randomElement() ?? ("No Verse", "No Explanation", "No Explanation")
    }
    
    @objc func fastingTypeChanged(_ sender: UISegmentedControl) {
        fastingTypeSelected = true
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
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 31
        case 1: return 24
        case 2: return 60
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(row) Days"
        case 1: return "\(row) Hours"
        case 2: return "\(row) Minutes"
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            fastingDays = row
        case 1:
            fastingHours = row
        case 2:
            fastingMinutes = row
        default:
            break
        }
        
        if fastingDays > 0 || fastingHours > 0 || fastingMinutes > 0 {
            fastingDurationSelected = true
            chooseDaysLabel.text = "Selected: \(fastingDays) Days, \(fastingHours) Hours, \(fastingMinutes) Minutes"
        }
    }
    
    func startHealthTipAnimation() {
        healthTipTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(animateHealthTip), userInfo: nil, repeats: true)
    }
    
    @objc func animateHealthTip() {
        
        UIView.animate(withDuration: 2.0, animations: {
            self.healthTipLabel.alpha = 0.0
        }) { _ in
            
            self.currentTipIndex = (self.currentTipIndex + 1) % self.healthTips.count
            self.healthTipLabel.text = self.healthTips[self.currentTipIndex]
            
            UIView.animate(withDuration: 1.0) {
                self.healthTipLabel.alpha = 1.0
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        healthTipTimer?.invalidate()
    }
    
    func stopHealthTipAnimation() {
        healthTipTimer?.invalidate()
    }
}

