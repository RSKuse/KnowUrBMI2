//
//  WorkoutViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit
import Lottie

class WorkoutViewController: UIViewController {

    var timer: Timer?
    var timeRemaining: Int = 2700 // 45 minutes in seconds (45 * 60)
    var caloriesBurned: Int = 0
    var userBMI: Float = 0.0
    var workoutCompletedDays: Int = 0
    var totalCaloriesBurned: Int = 3500 // Simulated calories burned for demonstration

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
        simulateGraph() // Simulate the graph display
    }
    
    func simulateGraph() {
        let progressVC = ProgressViewController()
        progressVC.totalCaloriesBurned = totalCaloriesBurned  // Pass simulated total calories
        navigationController?.pushViewController(progressVC, animated: true)
    }
    
    private func setupUI() {
        // Adding all views to the main view
        [workoutLabel, suggestionLabel, mealPlanLabel, startWorkoutButton, endWorkoutButton, workoutImageView, motivationLabel, timerLabel].forEach {
            view.addSubview($0)
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            workoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            workoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            suggestionLabel.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 20),
            suggestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            suggestionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mealPlanLabel.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor, constant: 20),
            mealPlanLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mealPlanLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startWorkoutButton.topAnchor.constraint(equalTo: mealPlanLabel.bottomAnchor, constant: 20),
            startWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startWorkoutButton.widthAnchor.constraint(equalToConstant: 200),
            startWorkoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            endWorkoutButton.topAnchor.constraint(equalTo: startWorkoutButton.bottomAnchor, constant: 20),
            endWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endWorkoutButton.widthAnchor.constraint(equalToConstant: 200),
            endWorkoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            workoutImageView.topAnchor.constraint(equalTo: endWorkoutButton.bottomAnchor, constant: 0),
            workoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workoutImageView.heightAnchor.constraint(equalToConstant: 200),
            
            motivationLabel.topAnchor.constraint(equalTo: workoutImageView.bottomAnchor, constant: 20),
            motivationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            motivationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            motivationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showWorkoutSuggestion() {
        if userBMI > 24.9 {
            suggestionLabel.text = "Suggested workout: 5 km run or 7 km walk for 5 days a week for 31 days."
            mealPlanLabel.text = "Meal plan: Eat high-protein, low-calorie meals, including lean meat, vegetables, and whole grains."
        } else if userBMI < 18.5 {
            suggestionLabel.text = "Focus on gaining healthy weight."
            mealPlanLabel.text = "Meal plan: Eat calorie-dense meals, including nuts, avocados, and healthy fats."
        } else {
            suggestionLabel.text = "Maintain a balanced diet and moderate exercise."
            mealPlanLabel.text = "Meal plan: Balanced diet with fruits, vegetables, proteins, and whole grains."
        }
    }
    
    @objc func startWorkout() {
        endWorkoutButton.isHidden = false
        startWorkoutButton.isHidden = true
        workoutCompletedDays += 1
        calculateCaloriesBurned()
        startTimer()
    }
    
    @objc func endWorkout() {
        pauseTimer()
        let alert = UIAlertController(title: "End Workout", message: "Do you really want to stop?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in self.resumeTimer() }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in self.resetTimer() }))
        present(alert, animated: true, completion: nil)
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
        timerLabel.text = "45:00"
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
        caloriesBurned += (userBMI > 24.9 ? 500 : 100) // Adjust calorie burn based on BMI
    }
    
    func showWorkoutResult() {
        let message = "In \(workoutCompletedDays) days, you've burned \(caloriesBurned) calories and lost approximately \(Double(caloriesBurned) / 7700) kg."
        let alertController = UIAlertController(title: "Workout Completed!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

    
