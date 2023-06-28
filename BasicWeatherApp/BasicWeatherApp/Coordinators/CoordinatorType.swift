//
//  CoordinatorType.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/28/23.
//

import UIKit


typealias CoordinatorType = CoordinatorBasicType & CoordinatorNavType

protocol CoordinatorBasicType {
    // TODO: Make universal or general container vs just navController
    // var navController: UINavigationController { get }
    func launch()
}

protocol CoordinatorNavType {
    func push(vc: UIViewController)
    func present(vc: UIViewController)
    func dismiss()
}
