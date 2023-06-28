//
//  DebugViewController.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/22/23.
//

import UIKit

class DebugViewController: UIViewController {

    private static let SettingHeight: CGFloat = 44
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(self.dismissButtonSelected), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: Self.SettingHeight).isActive = true
        return button
    }()
    
    // MARK: Update this to contain a scroll view for if/when settings exceed screen space
    lazy var animationDelayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Delay Load Animation: \(DebugSettings.shared.animationDelayTime)s"
        return label
    }()
    
    lazy var animationDelayStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.value = Double(DebugSettings.shared.animationDelayTime)
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(self.animationDelayStepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    private func setUp() {
        self.view.backgroundColor = .systemBackground
        
        let containerStack = UIStackView(axis: .vertical, alignment: .fill)
        
        let animationDelayStackView = UIStackView(axis: .horizontal, alignment: .fill)
        animationDelayStackView.addArrangedSubview(self.animationDelayLabel)
        animationDelayStackView.addArrangedSubview(UIView.generateSpacerView())
        animationDelayStackView.addArrangedSubview(self.animationDelayStepper)
        animationDelayStackView.heightAnchor.constraint(equalToConstant: Self.SettingHeight).isActive = true
        
        containerStack.addArrangedSubview(animationDelayStackView)
        containerStack.addArrangedSubview(UIView.generateSpacerView())
        
        self.view.addSubview(containerStack)
        self.view.addSubview(self.dismissButton)
        
        containerStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        containerStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        containerStack.bottomAnchor.constraint(equalTo: self.dismissButton.topAnchor, constant: -8).isActive = true
        self.dismissButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        self.dismissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.dismissButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    @objc
    func dismissButtonSelected() {
        self.dismiss(animated: true)
    }
    
    @objc
    func animationDelayStepperValueChanged() {
        self.animationDelayLabel.text = String(format: "Delay Load Animation: %ds", Int(self.animationDelayStepper.value))
        DebugSettings.shared.animationDelayTime = Int(self.animationDelayStepper.value)
    }

}
