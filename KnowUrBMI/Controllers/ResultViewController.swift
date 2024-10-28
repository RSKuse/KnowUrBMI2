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
    
    var workoutButton: UIButton?
    var fastingButton: UIButton?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Back"
        view.backgroundColor = color ?? .red

        setupUI()
        setupButtons()

        bmiLabel.text = bmiValue
        adviceLabel.text = advice

        // Check if BMI is out of normal range, and show or hide buttons accordingly
        if let bmi = bmiValue, let bmiFloat = Float(bmi) {
            if bmiFloat < 18.5 || bmiFloat > 24.9 {
                workoutButton?.isHidden = false
                fastingButton?.isHidden = false
            } else {
                workoutButton?.isHidden = true
                fastingButton?.isHidden = true
            }
        }
    }

    func setupButtons() {
        let buttonData = [
            ButtonData(title: "RECALCULATE", color: .systemPurple, action: #selector(recalculatePressed)),
            ButtonData(title: "Workout Suggestions", color: .systemBlue, action: #selector(workoutPressed)),
            ButtonData(title: "Fasting Ideas", color: .systemGreen, action: #selector(fastingPressed), isEnabled: true),
            ButtonData(title: "View Progress", color: .systemOrange, action: #selector(showProgress), isEnabled: true)
        ]

        let buttons = ButtonFacade.createButtons(buttonData, target: self)

        workoutButton = buttons.first { $0.title(for: .normal) == "Workout Suggestions" }
        fastingButton = buttons.first { $0.title(for: .normal) == "Fasting Ideas" }

        ButtonFacade.layoutButtons(buttons, in: view)
    }

    func setupUI() {
        view.addSubview(resultBackgroundImageView)
        view.addSubview(resultLabel)
        view.addSubview(bmiLabel)
        view.addSubview(adviceLabel)

        resultBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        resultBackgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        bmiLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20).isActive = true
        bmiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        adviceLabel.topAnchor.constraint(equalTo: bmiLabel.bottomAnchor, constant: 20).isActive = true
        adviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func workoutPressed() {
        let workoutVC = WorkoutViewController()
        workoutVC.userBMI = Float(bmiValue ?? "0") ?? 0.0
        workoutVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(workoutVC, animated: true)
    }

    @objc func fastingPressed() {
        let fastingVC = FastingViewController()
        navigationController?.pushViewController(fastingVC, animated: true)
    }

    @objc func recalculatePressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func showProgress() {
        let progressVC = ProgressViewController()
        navigationController?.pushViewController(progressVC, animated: true)
    }
}
