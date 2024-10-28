//
//  ButtonFacade.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/25.
//


import Foundation
import UIKit


struct ButtonData {
    var title: String
    var color: UIColor
    var action: Selector
    var isEnabled: Bool = true // Add this property to control the enabled state
}

class ButtonFacade {
    
    enum ButtonPosition {
        case center
        case bottom
    }
    
    // Main facade method that generates and lays out buttons
    static func createButtonsAndLayout(in view: UIView, buttonData: [ButtonData], target: AnyObject) {
        let buttons = createButtons(buttonData, target: target)
        layoutButtons(buttons, in: view)
        applyAdditionalEffects(to: buttons)
    }

    // Public generic method to create buttons
    static func createButtons(_ buttonData: [ButtonData], target: AnyObject) -> [UIButton] {
        return buttonData.map { data in
            createButton(data: data, target: target)
        }
    }

    // Generic button creation function
    private static func createButton(data: ButtonData, target: AnyObject) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(data.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = data.isEnabled ? data.color : .systemGray // Gray out if disabled
        button.layer.cornerRadius = 20
        button.isEnabled = data.isEnabled // Set enabled state
        button.addTarget(target, action: data.action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // Layout the buttons in a vertical stack inside the view
    static func layoutButtons(_ buttons: [UIButton], in view: UIView, position: ButtonPosition = .center) {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        // Set constraints based on position
        switch position {
        case .center:
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true

        case .bottom:
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }

        // Set constraints for each button
        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: 200).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    


    static func applyAdditionalEffects(to buttons: [UIButton]) {
        for button in buttons {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 4.0
        }
    }
}
