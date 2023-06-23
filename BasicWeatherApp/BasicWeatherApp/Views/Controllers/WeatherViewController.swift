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
 -Write unit tests
 -Add ScrollView Maybe or just remove landscape. Not the most practical with landscape
 -Implement a debug menu
 -Create SwiftUI Version and verify all non-UI code works as is without changes
 */

class WeatherViewController: UIViewController {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search City"
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: Probably does not work with Light / Dark Mode as is. Check for all views
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
    
    lazy var welcomeLabel: UILabel = {
        return UILabel(initialText: "Welcome, please search for the weather", alignment: .center)
    }()
    
    lazy var weatherView: WeatherView = {
        let weatherView = WeatherView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    let weatherViewModel: WeatherViewModelType
    private var subscribers = Set<AnyCancellable>()
    
    private var isLoading = false {
        didSet {
            self.welcomeLabel.isHidden = true
            self.searchBar.isEnabled = !self.isLoading
            self.myLocationButton.isEnabled = !self.isLoading
            self.searchBar.alpha = (self.isLoading) ? 0.25 : 1.0
            self.myLocationButton.alpha = (self.isLoading) ? 0.25 : 1.0
            self.weatherView.contentView.alpha = (self.isLoading) ? 0.25 : 1.0
            let action = (self.isLoading) ? self.weatherView.startLoading : self.weatherView.stopLoading
            action()
        }
    }
    
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
        self.weatherViewModel.loadMostRecentLocation {
            self.isLoading = true
        }
    }

    private func bind() {
        self.weatherViewModel.weatherFormattedPublisher
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isLoading = false
                
                switch result {
                case .success(let weatherformatter):
                    self?.weatherView.update(with: weatherformatter)
                case .failure:
                    self?.presentErrorAlert()
                }
            }.store(in: &self.subscribers)
    }
    
    // TODO: Refactor to include Scroll capability for smaller space
    private func setUp() {
        self.view.backgroundColor = .systemBackground
        
        let vStack = UIStackView(axis: .vertical, alignment: .fill)
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.myLocationButton)
        
        let topSpacer = UIView.generateSpacerView()
        let bottomSpacer = UIView.generateSpacerView()
        
        vStack.addArrangedSubview(topSpacer)
        vStack.addArrangedSubview(self.welcomeLabel)
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
        self.isLoading = true
        self.weatherViewModel.loadCurrentLocationWeather()
    }

}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search!!!!")
        guard let query = searchBar.text, !query.isEmpty else { return }
        self.isLoading = true
        self.weatherViewModel.loadQueriedLocationWeather(query: query)
    }
    
}
