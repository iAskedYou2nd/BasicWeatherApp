//
//  WeatherView.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import UIKit

class WeatherView: UIView {
    
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var loadingView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var locationLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center, font: UIFont.systemFont(ofSize: 24))
    }()
    
    lazy var tempLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center, font: UIFont.systemFont(ofSize: 30))
    }()
    
    lazy var minMaxFeelsLikeLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(systemName: "cloud.sun.rain")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    lazy var iconDescriptionLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var pressureLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var humidityLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var windSpeedLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var cloudCoveragePercentLabel: UILabel = {
        return UILabel(initialText: "", alignment: .center)
    }()
    
    lazy var loadSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        spinner.isHidden = true
        return spinner
    }()
    
    func startLoading() {
        self.loadSpinner.isHidden = false
        self.loadSpinner.startAnimating()
        
    }
    
    func stopLoading() {
        self.loadSpinner.isHidden = true
        self.loadSpinner.stopAnimating()
    }
    
    
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
        
        self.contentView.addSubview(outerVStack)
        outerVStack.bindToContainerView()
        self.addSubview(self.contentView)
        self.contentView.bindToContainerView(edges: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.insertSubview(self.loadSpinner, at: 0)
        self.loadSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loadSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func update(with weatherFormatter: WeatherFormatter) {
        self.locationLabel.text = weatherFormatter.locationName
        self.tempLabel.text = weatherFormatter.temperature
        self.minMaxFeelsLikeLabel.text = weatherFormatter.minMaxFeelsLike
        self.weatherIconImageView.image = UIImage(data: weatherFormatter.iconData)
        self.iconDescriptionLabel.text = weatherFormatter.iconDescription
        self.pressureLabel.text = weatherFormatter.pressure
        self.humidityLabel.text = weatherFormatter.humidity
        self.windSpeedLabel.text = weatherFormatter.windSpeed
        self.cloudCoveragePercentLabel.text = weatherFormatter.cloudCoverage
    }
    
}
