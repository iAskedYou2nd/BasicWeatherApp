//
//  UIViewControllerExtension.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/7/23.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Uh Oh", message: "Looks like something went wrong. Please try again later", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
}
