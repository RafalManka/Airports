//
//  AirportsViewModel.swift
//  EmiratesBooking
//
//  Created by rafal.manka on 23/07/2018.
//  Copyright © 2018 Emirates Airlines. All rights reserved.
//

import Foundation

public enum AirportError {
    
}

public class AirportsViewModel {
    
    public var didErrorOccur: ((AirportError) -> Void)?
    public var didProgressChange: ((Bool) -> Void)?
    public var didAirportsChange: (([Airport]) -> Void)?
    public var didNearestAirportChange: ((Airport) -> Void)?
    
    let repository = AirportRepository()
    
    public init() {
        // nothing
    }
    
    public func refreshNearestAirports(latitude: Double, longitude: Double) {
        didProgressChange?(true)
        let didRefreshNearestAirport: (Airport) -> Void = { airport in
            self.didProgressChange?(false)
            self.didNearestAirportChange?(airport)
        }
        let didRefreshAllAirports: ([Airport]) -> Void = { airports in
            self.didAirportsChange?(airports)
        }
        repository.refreshNearestAirport(latitude: latitude, longitude: longitude, didRefreshNearestAirport: didRefreshNearestAirport, didRefreshAllAirports: didRefreshAllAirports)
    }
    
    public func refreshAirports() {
        didProgressChange?(true)
        let didRefreshAllAirports: ([Airport]) -> Void = { airports in
            self.didProgressChange?(false)
            self.didAirportsChange?(airports)
        }
        repository.refreshAllAirports(didRefreshAllAirports: didRefreshAllAirports)
    }
}
