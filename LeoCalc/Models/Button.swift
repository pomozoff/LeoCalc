//
//  Button.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 18.07.2021.
//

import Foundation

struct Button {
    let place: ButtonPlace
    let action: Action

    var isEnabled: Bool { action.isEnabled }
    var title: String { action.name }
}

extension Button: Equatable {}
