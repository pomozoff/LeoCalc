//
//  ErrorPresentable.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 25.07.2021.
//

import UIKit

protocol ErrorPresentable: AnyObject {
    func presentAlert(title: String, message: String)
}
