//
//  ViewController.swift
//  Airports
//
//  Created by rafal.manka on 05/08/2018.
//  Copyright © 2018 Rafal Manka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var allAirportsLabel: UILabel!
    @IBOutlet weak var nearestAirportsLabel: UILabel!
    
    
    let viewModel = AirportsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didAirportsChange = { [weak self] airports in
            self?.allAirportsLabel.text = "All airports count = \(airports.count)"
        }
        viewModel.didNearestAirportChange = { [weak self] nearest in
            self?.nearestAirportsLabel.text = "Nearest airport = \(nearest.name)"
        }
        viewModel.refreshNearestAirports(latitude: 25.078828, longitude: 55.135345)
    }

}

