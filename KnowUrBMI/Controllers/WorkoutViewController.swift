//
//  WorkoutViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.

import Foundation
import UIKit
import Lottie

class WorkoutViewController: UIViewController {

    var timer: Timer?
    var timeRemaining: Int = 2700
    var caloriesBurned: Int = 0
    var userBMI: Float = 0.0
    var workoutCompletedDays: Int = 0

    lazy var backgroundView: UIView = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }()
    
    lazy var workoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Workout Suggestion"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.layer.shadowColor = UIColor.systemPurple.cgColor
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mealPlanLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.layer.shadowColor = UIColor.systemBlue.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Motivational Text (futuristic glow)
    lazy var motivationLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay Strong! Your Health is Your Wealth 💪"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.layer.shadowColor = UIColor.systemPurple.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        applyGradientBackground()
        setupUI()
        setupButtons()
        showWorkoutSuggestion()
    }

    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.gray.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private func setupButtons() {
        let buttonData = [
            ButtonData(title: "Start Workout", color: .systemGreen, action: #selector(startWorkout), isEnabled: true),
            ButtonData(title: "End Workout", color: .systemRed, action: #selector(endWorkout), isEnabled: true) // Start as disabled
        ]
        let buttons = ButtonFacade.createButtons(buttonData, target: self)
        ButtonFacade.layoutButtons(buttons, in: view, position: .bottom)
    }
    
    
    private func setupUI() {

        view.addSubview(motivationLabel)
        view.addSubview(workoutImageView)
        view.addSubview(workoutLabel)
        view.addSubview(suggestionLabel)
        view.addSubview(mealPlanLabel)
        view.addSubview(timerLabel)
        view.addSubview(motivationLabel)
        view.addSubview(workoutImageView)

        workoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        workoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        workoutImageView.topAnchor.constraint(equalTo: workoutLabel.bottomAnchor, constant: 10).isActive = true
        workoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        workoutImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        workoutImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        motivationLabel.topAnchor.constraint(equalTo: workoutImageView.bottomAnchor, constant: 10).isActive = true
        motivationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        motivationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        suggestionLabel.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 10).isActive = true
        suggestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        suggestionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        mealPlanLabel.topAnchor.constraint(equalTo: suggestionLabel.bottomAnchor, constant: 10).isActive = true
        mealPlanLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mealPlanLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        timerLabel.topAnchor.constraint(equalTo: mealPlanLabel.bottomAnchor, constant: 20).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  
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
        toggleWorkoutButtons(isStarted: true)
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
        timer?.invalidate()
        timeRemaining = 2700
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }

    func resumeTimer() {
        startTimer()
    }

    func resetTimer() {
        timer?.invalidate()
        timeRemaining = 2700
        timerLabel.text = "45:00"
        toggleWorkoutButtons(isStarted: false)
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
    
    func calculateCaloriesBurned() -> Int {
        let calories = (userBMI > 24.9 ? 500 : 100) // Calculate based on condition
        return calories // Ensure this function returns an Int value
    }
    
    func showWorkoutResult() {
        let message = "In \(workoutCompletedDays) days, you've burned \(caloriesBurned) calories and lost approximately \(Double(caloriesBurned) / 7700) kg."
        let alertController = UIAlertController(title: "Workout Completed!", message: message, preferredStyle: .alert)
        let caloriesBurned = calculateCaloriesBurned()
        let currentWeight: Float = 70.0 // Fetch or update weight data if available
        ProgressDataManager.shared.addData(for: Date(), calories: caloriesBurned, weight: currentWeight)
        ProgressDataManager.shared.saveData() // Save after updating
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func toggleWorkoutButtons(isStarted: Bool) {
        if let startWorkoutButton = view.subviews.compactMap({ $0 as? UIButton }).first(where: { $0.title(for: .normal) == "Start Workout" }),
           let endWorkoutButton = view.subviews.compactMap({ $0 as? UIButton }).first(where: { $0.title(for: .normal) == "End Workout" }) {
            startWorkoutButton.isHidden = isStarted
            endWorkoutButton.isHidden = !isStarted
        }
    }

    
}
