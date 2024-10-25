//
//  ButtonFacade.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/10/25.
//

import Foundation
import Foundation
import UIKit

// Facade class to simplify interaction for creating and managing buttons
// Facade class to simplify interaction for creating and managing buttons
class ButtonFacade {
    
    // Main facade method that generates and lays out buttons
    static func createButtonsAndLayout(in view: UIView, buttonData: [(title: String, color: UIColor, action: Selector)], target: AnyObject) {
        let buttons = createButtons(buttonData, target: target)
        layoutButtons(buttons, in: view)
        applyAdditionalEffects(to: buttons)
    }

    // Public generic method to create buttons (changed from private to public)
    static func createButtons(_ buttonData: [(title: String, color: UIColor, action: Selector)], target: AnyObject) -> [UIButton] {
        return buttonData.map { data in
            createButton(title: data.title, backgroundColor: data.color, target: target, action: data.action)
        }
    }

    // Generic button creation function
    private static func createButton(title: String, backgroundColor: UIColor, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // Layout the buttons in a vertical stack inside the view
    static func layoutButtons(_ buttons: [UIButton], in view: UIView) {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)


            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true // Adjusting placement to avoid overlap


        // Set constraints for each button
        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: 200).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }

    // Apply shadow and gradient after layout
    static func applyAdditionalEffects(to buttons: [UIButton]) {
        for button in buttons {
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 4.0
        }
    }
}

