//
//  ResultViewController.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/09/16.
//

import UIKit

class ResultViewController: UIViewController {

    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    
    lazy var resultBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "result_background")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "YOUR RESULT"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bmiLabel: UILabel = {
        let label = UILabel()
        label.text = bmiValue
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.text = advice
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var workoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Workout Suggestions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(workoutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fastingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fasting Ideas", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(fastingPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var recalculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("RECALCULATE", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(recalculatePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var progressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Progress", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showProgress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Back"
        
        view.backgroundColor = color ?? .red
        
        setupUI()
        
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
        
        if let bmi = bmiValue, let bmiFloat = Float(bmi) {
          
            if bmiFloat < 18.5 || bmiFloat > 24.9 {
                workoutButton.isHidden = false
                fastingButton.isHidden = false
            } else {
                workoutButton.isHidden = true
                fastingButton.isHidden = true
            }
        }
    }
    
    func setupUI() {
        view.addSubview(resultBackgroundImageView)
        view.addSubview(resultLabel)
        view.addSubview(bmiLabel)
        view.addSubview(adviceLabel)
        view.addSubview(recalculateButton)
        view.addSubview(workoutButton)
        view.addSubview(fastingButton)
        view.addSubview(progressButton)
        
        resultBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        resultBackgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bmiLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20).isActive = true
        bmiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        adviceLabel.topAnchor.constraint(equalTo: bmiLabel.bottomAnchor, constant: 20).isActive = true
        adviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        workoutButton.topAnchor.constraint(equalTo: adviceLabel.bottomAnchor, constant: 40).isActive = true
        workoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        workoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        workoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fastingButton.topAnchor.constraint(equalTo: workoutButton.bottomAnchor, constant: 20).isActive = true
        fastingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastingButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        fastingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        recalculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        recalculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recalculateButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        recalculateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        progressButton.topAnchor.constraint(equalTo: fastingButton.bottomAnchor, constant: 20).isActive = true
        progressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        progressButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func workoutPressed() {
        let workoutVC = WorkoutViewController()
        
        // Pass calculated BMI and advice from ResultViewController to WorkoutViewController
        workoutVC.userBMI = Float(bmiValue ?? "0") ?? 0.0
        
        workoutVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(workoutVC, animated: true)
    }
    
    @objc func fastingPressed() {
        let fastingVC = FastingViewController()
        navigationController?.pushViewController(fastingVC, animated: true)
    }
    
    @objc func recalculatePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showProgress() {
        let progressVC = ProgressViewController()
        navigationController?.pushViewController(progressVC, animated: true)
    }
}
