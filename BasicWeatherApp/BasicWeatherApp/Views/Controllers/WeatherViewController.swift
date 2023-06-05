//
//  WeatherViewController.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 5/31/23.
//

import UIKit
import Combine

/*
 TODO List:
 -Finish ViewModel(s)
    -Create WeatherViewModel for presentation and icon image. Give more accuate name for viewmodels
 -Keyboard appearance with constraints
 -Add initial visuals for UX on initial launch with empty persist store
 -Write unit tests
 -Add ScrollView Maybe
 -Create SwiftUI Version
 -Implement a debug menu
 -Add Load animation
 */

class WeatherViewController: UIViewController {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search City"
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: Probably does not work with Light / Dark Mode as is. Check
    lazy var myLocationButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Current Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(self.locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var weatherView: WeatherView = {
        let weatherView = WeatherView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    let weatherViewModel: WeatherViewModelType
    private var subscribers = Set<AnyCancellable>()
    
    init(viewModel: WeatherViewModelType = WeatherViewModel()) {
        self.weatherViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.bind()
        self.weatherViewModel.loadMostRecentLocation()
    }

    private func bind() {
        self.weatherViewModel.weatherDataPublisher
            .receive(on: DispatchQueue.main)
            .zip(self.weatherViewModel.weatherIconDataPublisher)
            .sink { [weak self] (weather: (weatherModel: WeatherModel, iconData: Data)) in
                self?.weatherView.locationLabel.text = weather.weatherModel.name
                self?.weatherView.tempLabel.text = "\(weather.weatherModel.main.temp)°"
                self?.weatherView.minMaxFeelsLikeLabel.text = "\(weather.weatherModel.main.tempMin)° / \(weather.weatherModel.main.tempMax)° Feels like \(weather.weatherModel.main.feelsLike)°"
                self?.weatherView.weatherIconImageView.image = UIImage(data: weather.iconData)
                self?.weatherView.iconDescriptionLabel.text = weather.weatherModel.weather.first?.description
                self?.weatherView.pressureLabel.text = "Pressure: \(weather.weatherModel.main.pressure)hPa"
                self?.weatherView.humidityLabel.text = "Humidity: \(weather.weatherModel.main.humidity)%"
                self?.weatherView.windSpeedLabel.text = "Wind Speed: \(weather.weatherModel.wind.speed)mph"
                self?.weatherView.cloudCoveragePercentLabel.text = "Cloud Coverage: \(weather.weatherModel.clouds.all)%"
            }.store(in: &self.subscribers)
    }
    
    // TODO: Refactor to include Scroll capability for smaller space
    private func setUp() {
        self.view.backgroundColor = .white
        
        let vStack = UIStackView(axis: .vertical, alignment: .fill)
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.myLocationButton)
        
        let topSpacer = UIView.generateSpacerView()
        let bottomSpacer = UIView.generateSpacerView()
        
        vStack.addArrangedSubview(topSpacer)
        vStack.addArrangedSubview(self.weatherView)
        vStack.addArrangedSubview(bottomSpacer)
        
        topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor).isActive = true
        
        self.view.addSubview(vStack)
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.myLocationButton.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 8).isActive = true
        self.myLocationButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        vStack.topAnchor.constraint(equalTo: self.myLocationButton.bottomAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc
    func locationButtonPressed() {
        self.weatherViewModel.loadCurrentLocationWeather()
    }


}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search!!!!")
        guard let query = searchBar.text, !query.isEmpty else { return }
        self.weatherViewModel.loadQueriedLocationWeather(query: query)
    }
    
}
