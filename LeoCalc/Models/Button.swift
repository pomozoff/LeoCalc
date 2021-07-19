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
    let isEnabled: Bool
    let isVisible: Bool

    var title: String { action.title }
}
