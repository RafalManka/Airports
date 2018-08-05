//
//  ViewController.swift
//  Airports
//
//  Created by rafal.manka on 05/08/2018.
//  Copyright © 2018 Rafal Manka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = AirportsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didAirportsChange = { airports in
            print("airports = \(airports)")
        }
        viewModel.refreshAirports()
    }

}

