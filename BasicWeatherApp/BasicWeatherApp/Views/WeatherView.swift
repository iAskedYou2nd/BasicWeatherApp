//
//  WeatherView.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import UIKit

class WeatherView: UIView {

    lazy var locationLabel: UILabel = {
        return UILabel(initialText: "Location Name", alignment: .center, font: UIFont.systemFont(ofSize: 24))
    }()
    
    lazy var tempLabel: UILabel = {
        return UILabel(initialText: "Temp", alignment: .center, font: UIFont.systemFont(ofSize: 30))
    }()
    
    lazy var minMaxFeelsLikeLabel: UILabel = {
        return UILabel(initialText: "Min / Max Feels Like", alignment: .center)
    }()
    
    // TODO: Create custom ImageView with one of my animations for the loading
    lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "cloud.sun.rain")
//        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    lazy var iconDescriptionLabel: UILabel = {
        return UILabel(initialText: "Description", alignment: .center)
    }()
    
    lazy var pressureLabel: UILabel = {
        return UILabel(initialText: "Pressure", alignment: .center)
    }()
    
    lazy var humidityLabel: UILabel = {
        return UILabel(initialText: "Humidity", alignment: .center)
    }()
    
    lazy var windSpeedLabel: UILabel = {
        return UILabel(initialText: "Wind Speed mph", alignment: .center)
    }()
    
    lazy var cloudCoveragePercentLabel: UILabel = {
        return UILabel(initialText: "Cloud Coverage %", alignment: .center)
    }()
    
    // Inject in a formulated Wrapper / ViewModel for the properties
    init() {
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let outerVStack = UIStackView(axis: .vertical, alignment: .center)
        let hStack = UIStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually)
        let innerLeftVStack = UIStackView(axis: .vertical, alignment: .center)
        let innerRightVStack = UIStackView(axis: .vertical, alignment: .center)
        
        innerLeftVStack.addArrangedSubview(UIView.generateSpacerView())
        innerLeftVStack.addArrangedSubview(self.tempLabel)
        innerLeftVStack.addArrangedSubview(self.minMaxFeelsLikeLabel)
        innerLeftVStack.addArrangedSubview(UIView.generateSpacerView())
        
        innerRightVStack.addArrangedSubview(UIView.generateSpacerView())
        innerRightVStack.addArrangedSubview(self.weatherIconImageView)
        innerRightVStack.addArrangedSubview(self.iconDescriptionLabel)
        innerRightVStack.addArrangedSubview(UIView.generateSpacerView())

        hStack.addArrangedSubview(innerLeftVStack)
        hStack.addArrangedSubview(innerRightVStack)
        
        outerVStack.addArrangedSubview(self.locationLabel)
        outerVStack.addArrangedSubview(hStack)
        outerVStack.addArrangedSubview(self.pressureLabel)
        outerVStack.addArrangedSubview(self.humidityLabel)
        outerVStack.addArrangedSubview(self.windSpeedLabel)
        outerVStack.addArrangedSubview(self.cloudCoveragePercentLabel)
        
        self.addSubview(outerVStack)
        outerVStack.bindToContainerView()
    }
    
}
