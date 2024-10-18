//
//  WorkoutViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/16.
//

import Foundation
import UIKit
//import Lottie

class WorkoutViewController: UIViewController {

    var timer: Timer?
    var timeRemaining: Int = 1800
    var caloriesBurned: Int = 0
    var userBMI: Float = 0.0
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "30:00"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motivationLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay Strong! Your Health is Your Wealth 💪"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var workoutImageView: LottieAnimationView = {
//        let animationView = LottieAnimationView(name: "workout_animation")
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        return animationView
//    }()
    
    lazy var workoutRoutineLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Workout: 30 min Cardio, 15 min Strength Training"
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var startWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Workout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startWorkoutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(motivationLabel)
//        view.addSubview(workoutImageView)
        view.addSubview(workoutRoutineLabel)
        view.addSubview(timerLabel)
        view.addSubview(startWorkoutButton)
        
        // Set constraints
        motivationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        motivationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        motivationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
//        workoutImageView.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 20).isActive = true
//        workoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        workoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        workoutImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        workoutRoutineLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        workoutRoutineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        workoutRoutineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: workoutRoutineLabel.bottomAnchor, constant: 20).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        startWorkoutButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20).isActive = true
        startWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startWorkoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startWorkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func startWorkoutPressed() {

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
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
    
    func showWorkoutResult() {

        if userBMI > 24.9 {
            caloriesBurned = 300
        } else if userBMI < 18.5 {
            caloriesBurned = 100
        } else {
            caloriesBurned = 200
            
        }
        
        let alertController = UIAlertController(title: "Workout Complete!", message: "You have burned \(caloriesBurned) calories!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
