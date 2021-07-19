//
//  UICollectionView+Extensions.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 17.07.2021.
//

import UIKit

extension UICollectionView {
    var reuseIdentifier: String {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.reuseIdentifier) as? String ?? ""
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.reuseIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private struct AssociatedKeys {
    static var reuseIdentifier: UInt8 = 0
}
