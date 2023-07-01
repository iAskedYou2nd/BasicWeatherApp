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
    lazy var apiDelayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Delay API Fetch: \(DebugSettings.shared.apiDelayTime)s"
        return label
    }()
    
    lazy var apiDelayStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.value = Double(DebugSettings.shared.apiDelayTime)
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(self.animationDelayStepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    lazy var imageDelayLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Delay Image Fetch: \(DebugSettings.shared.imageDelayTime)s"
        return label
    }()
    
    lazy var imageDelayStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.value = Double(DebugSettings.shared.imageDelayTime)
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(self.imageDelayStepperValueChanged), for: .valueChanged)
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
        animationDelayStackView.addArrangedSubview(self.apiDelayLabel)
        animationDelayStackView.addArrangedSubview(UIView.generateSpacerView())
        animationDelayStackView.addArrangedSubview(self.apiDelayStepper)
        animationDelayStackView.heightAnchor.constraint(equalToConstant: Self.SettingHeight).isActive = true
        
        let imageDelayStackView = UIStackView(axis: .horizontal, alignment: .fill)
        imageDelayStackView.addArrangedSubview(self.imageDelayLabel)
        imageDelayStackView.addArrangedSubview(UIView.generateSpacerView())
        imageDelayStackView.addArrangedSubview(self.imageDelayStepper)
        imageDelayStackView.heightAnchor.constraint(equalToConstant: Self.SettingHeight).isActive = true
        
        containerStack.addArrangedSubview(animationDelayStackView)
        containerStack.addArrangedSubview(imageDelayStackView)
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
        self.apiDelayLabel.text = String(format: "Delay API Fetch: %ds", Int(self.apiDelayStepper.value))
        DebugSettings.shared.apiDelayTime = Int(self.apiDelayStepper.value)
    }
    
    @objc
    func imageDelayStepperValueChanged() {
        self.imageDelayLabel.text = String(format: "Delay Image Fetch: %ds", Int(self.imageDelayStepper.value))
        DebugSettings.shared.imageDelayTime = Int(self.imageDelayStepper.value)
    }

}
