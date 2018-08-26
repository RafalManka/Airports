//
//  AirportRepository.swift
//  AirlineBooking
//
//  Created by rafal.manka on 23/07/2018.
//  Copyright © 2018 Airline Airlines. All rights reserved.
//

import Foundation

fileprivate let fallbackLanguage = "en"
fileprivate let supportedLanguages = [fallbackLanguage, "pl", "de"]

class LanguageProvider {
    var deviceCode: String {
        get {
            if let languageCode = Locale.current.languageCode, supportedLanguages.contains(languageCode) {
                return languageCode
            }
            return fallbackLanguage
        }
    }
}


class AirportRepository {

    let airportsPersistence = AirportPersistence()
    let nearestAirportsPersistence = NearestAirportsPersistence()
    let service = AirportService()
    let languageProvider = LanguageProvider()

    func refreshAllAirports(didRefreshAllAirports: @escaping ([Airport]) -> Void) {
        guard let airports = airportsPersistence.airports else {
            service.fetchAirports(languageProvider.deviceCode) { airports in
                self.airportsPersistence.airports = airports
                self.refreshAllAirports(didRefreshAllAirports: didRefreshAllAirports)
            }
            return
        }
        didRefreshAllAirports(airports)
    }

    func refreshNearestAirport(latitude: Double, longitude: Double, didRefreshNearestAirport: @escaping (Airport) -> Void, didRefreshAllAirports: @escaping ([Airport]) -> Void) {
        guard let airports = airportsPersistence.airports else {
            service.fetchAirports(languageProvider.deviceCode) { airports in
                self.airportsPersistence.airports = airports
                self.refreshNearestAirport(latitude: latitude, longitude: longitude, didRefreshNearestAirport: didRefreshNearestAirport, didRefreshAllAirports: didRefreshAllAirports)
            }
            return
        }
        didRefreshAllAirports(airports)
        guard let nearestAirports = nearestAirportsPersistence.getNearestAirports(latitude: latitude, longitude: longitude) else {
            service.fetchNearestAirports(latitude: latitude, longitude: longitude) { nearestAirports in
                self.nearestAirportsPersistence.saveNearestAirports(nearestAirports, latitude: latitude, longitude: longitude)
                self.refreshNearestAirport(latitude: latitude, longitude: longitude, didRefreshNearestAirport: didRefreshNearestAirport, didRefreshAllAirports: didRefreshAllAirports)
            }
            return
        }
        let nearest = nearestAirports.map { code in airports.first(where: { airport in  airport.code == code }) }.compactMap { $0 }
        if nearest.count > 0 {
            didRefreshNearestAirport(nearest[0])
        }
    }
}
