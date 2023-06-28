//
//  DebugMenuCoordinator.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/28/23.
//

import UIKit

class DebugMenuCoordinator: NSObject, CoordinatorBasicType {
    
    private static let DebugMenuSize: CGFloat = 20
    
    private lazy var debugButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Self.DebugMenuSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: Self.DebugMenuSize).isActive = true
        button.setImage(UIImage(named: "question-mark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.presentDebugMenu), for: .touchUpInside)
        return button
    }()
    
    private let navController: UINavigationController
    
    init(navController: UINavigationController = UINavigationController()) {
        self.navController = navController
    }
    
    // SetUp Code goes here
    func launch() {
        self.navController.delegate = self
        self.navController.navigationBar.isHidden = true
    }
    
    @objc
    func presentDebugMenu() {
        let debugVC = DebugViewController()
        debugVC.modalPresentationStyle = .fullScreen
        debugVC.modalTransitionStyle = .crossDissolve
        self.navController.topViewController?.present(debugVC, animated: true)
    }
    
}

extension DebugMenuCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        #if DEBUG
        self.debugButton.removeFromSuperview()
        viewController.view.addSubview(self.debugButton)
        self.debugButton.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.debugButton.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        #endif
    }
    
}
