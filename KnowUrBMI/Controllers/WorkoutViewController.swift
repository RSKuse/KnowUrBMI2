//
//  WorkoutViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit
import Lottie
import Charts
import DGCharts

class WorkoutViewController: UIViewController {

    var timer: Timer?
    var timeRemaining: Int = 2700 // 45 minutes in seconds (45 * 60)
    var caloriesBurned: Int = 0
    var userBMI: Float = 0.0
    var workoutCompletedDays: Int = 0
    var totalCaloriesBurned: Int = 0 // For 7-day tracking

    // Workout Suggestion Label
    lazy var workoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Workout Suggestion"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Workout Suggestion Description
    lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Meal Plan Label
    lazy var mealPlanLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Start Workout Button
    lazy var startWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Workout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startWorkout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // End Workout Button
    lazy var endWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("End Workout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addTarget(self, action: #selector(endWorkout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Timer Label
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Motivational Text
    lazy var motivationLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay Strong! Your Health is Your Wealth 💪"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Lottie Animation View
    lazy var workoutImageView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "workout_animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        showWorkoutSuggestion()
    }
    
    private func setupUI() {
        view.addSubview(motivationLabel)
        view.addSubview(workoutImageView)
        view.addSubview(workoutLabel)
        view.addSubview(suggestionLabel)
        view.addSubview(mealPlanLabel)
        view.addSubview(startWorkoutButton)
        view.addSubview(endWorkoutButton)
        view.addSubview(timerLabel)
        
        // Constraints
        workoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        workoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        suggestionLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 20).isActive = true
        suggestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        suggestionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        mealPlanLabel.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor, constant: 20).isActive = true
        mealPlanLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mealPlanLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        startWorkoutButton.topAnchor.constraint(equalTo: mealPlanLabel.bottomAnchor, constant: 20).isActive = true
        startWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startWorkoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startWorkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        endWorkoutButton.topAnchor.constraint(equalTo: startWorkoutButton.bottomAnchor, constant: 20).isActive = true
        endWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endWorkoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        endWorkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        workoutImageView.topAnchor.constraint(equalTo: startWorkoutButton.bottomAnchor, constant: 40).isActive = true
        workoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        workoutImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        motivationLabel.topAnchor.constraint(equalTo: workoutImageView.bottomAnchor, constant: 20).isActive = true
        motivationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        motivationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        motivationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 20).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func showWorkoutSuggestion() {
        print("User BMI: \(userBMI)")
        
        if userBMI > 24.9 {
            suggestionLabel.text = "Suggested workout: 5 km run or 7 km walk for 5 days a week for 31 days."
            mealPlanLabel.text = "Meal plan: Eat high-protein, low-calorie meals, including lean meat, vegetables, and whole grains."
            startWorkoutButton.isHidden = false
        } else if userBMI < 18.5 {
            suggestionLabel.text = "Focus on gaining healthy weight."
            mealPlanLabel.text = "Meal plan: Eat calorie-dense meals, including nuts, avocados, and healthy fats."
            startWorkoutButton.isHidden = false
        } else {
            suggestionLabel.text = "Maintain a balanced diet and moderate exercise."
            mealPlanLabel.text = "Meal plan: Balanced diet with fruits, vegetables, proteins, and whole grains."
            startWorkoutButton.isHidden = false
        }
    }
    
    @objc func startWorkout() {
        startWorkoutButton.isHidden = false
        endWorkoutButton.isHidden = false
        workoutCompletedDays += 1
        calculateCaloriesBurned()
        startTimer()
    }
    
    @objc func endWorkout() {

        pauseTimer()

        let alert = UIAlertController(title: "End Workout", message: "Do you really want to stop?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            self.resumeTimer() // Resume timer if No
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.resetTimer() // Reset timer if Yes
        }))
        present(alert, animated: true, completion: nil)
        
        endWorkoutButton.isHidden = false
        startWorkoutButton.isHidden = false
        showWorkoutResult()
    }
    
    func startTimer() {
        timer?.invalidate()  // Reset timer
        timeRemaining = 2700 // 45 minutes (45 * 60 seconds)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()  // Pause timer
    }

    func resumeTimer() {
        startTimer()  // Resume timer from where it left off
    }

    func resetTimer() {
        timer?.invalidate()  // Stop timer
        timeRemaining = 2700  // Reset to 45 minutes
        timerLabel.text = "45:00"  // Update the timer label
        endWorkoutButton.isHidden = true
        startWorkoutButton.isHidden = false
    }
    
    @objc func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            let minutes = timeRemaining / 60
            let seconds = timeRemaining % 60
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            timer?.invalidate()
            showWorkoutResult()
        }
    }
    
    func calculateCaloriesBurned() {
        if userBMI > 24.9 {
            caloriesBurned += 500 // Assuming 500 calories burned per 5 km run or 7 km walk
        }
    }
    
    func showWorkoutResult() {
        if userBMI > 24.9 {
            caloriesBurned = 500 // Example calorie burn
        } else if userBMI < 18.5 {
            caloriesBurned = 100 // Low-calorie burn for gaining weight
        }

        let estimatedWeightLoss = Double(caloriesBurned) / 7700 // Approx 7700 calories = 1kg weight loss
        let message = "In \(workoutCompletedDays) days, you've burned \(caloriesBurned) calories and lost approximately \(String(format: "%.2f", estimatedWeightLoss)) kg."
        let alertController = UIAlertController(title: "Workout Completed!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        if workoutCompletedDays >= 7 {
            showCaloriesGraph()
        }
        
    }

    func showCaloriesGraph() {
        let graphVC = GraphViewController()
        graphVC.totalCaloriesBurned = totalCaloriesBurned  // Pass total calories to the GraphViewController
        navigationController?.pushViewController(graphVC, animated: true)
    }
}

class GraphViewController: UIViewController {

    var totalCaloriesBurned: Int = 0

    lazy var chartView: PieChartView = {
        let chart = PieChartView()
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
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    private func updateChartData() {
        let entries = [
            PieChartDataEntry(value: Double(totalCaloriesBurned), label: "Calories Burned"),
            PieChartDataEntry(value: Double(7700 - totalCaloriesBurned), label: "Remaining to Lose 1kg")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
    }
}
    
