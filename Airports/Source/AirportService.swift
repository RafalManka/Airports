//
//  AirportService.swift
//  AirlineBooking
//
//  Created by rafal.manka on 23/07/2018.
//  Copyright © 2018 Airlines. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let baseUrl = "http://demo2542923.mockable.io"

struct UrlRepository {
    let fetchAirports = baseUrl + "/airport/list/v1?lang=en"
    let fetchNearestAirports = baseUrl + "/airport/nearest/v1"
}

struct CredentialsProvider {
    let headers: HTTPHeaders = [
        "Authorization": "IwFLQhwPuVJV6Pzg6yOo5D11waNszXcgZdou6htSkhPV",
        "apptype": "android",
        "X-Api-Version": "4.5.0",
        "DTKN": "ActFvHgz2KildXz"
    ]
}


class AirportService {
    
    let credentials = CredentialsProvider()
    let urls = UrlRepository()
    
    func fetchAirports(_ language: String, didFetchAirports: @escaping ([Airport]) -> Void)  {
        Alamofire.request(urls.fetchAirports, method: .get, headers: credentials.headers)
            .responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let allAirports = try JSONDecoder().decode([Airport].self, from: data)
                    didFetchAirports(allAirports)
                } catch let jsonError {
                    print(jsonError)
                }
        }
    }
    
    func fetchNearestAirports(latitude: Double, longitude: Double, didFetchNearestAirports: @escaping ([String]) -> Void ) {
        Alamofire.request(urls.fetchNearestAirports, method: .get, parameters: ["latitude": latitude, "longitude": longitude], encoding: URLEncoding(destination: .queryString), headers: credentials.headers)
            .responseJSON { response in
                guard let data = response.data else { return }
                do {
                    let nearestAirports = try JSONDecoder().decode([String].self, from: data)
                    didFetchNearestAirports(nearestAirports)
                } catch let jsonError {
                    print(jsonError)
                }
        }
    }
}
