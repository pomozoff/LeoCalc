//
//  MainViewController.swift
//  LeoCalc
//
//  Created by Anton Pomozov on 15.07.2021.
//

import UIKit
import ViewModelKit

class MainViewController: UIViewController {
    private(set) var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension MainViewController: ViewModelConfigurable {
    func configure(with viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}
