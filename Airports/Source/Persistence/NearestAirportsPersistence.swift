//
//  NearestAirportsPersistence.swift
//  EmiratesBooking
//
//  Created by rafal.manka on 31/07/2018.
//  Copyright © 2018 Emirates Airlines. All rights reserved.
//

import UIKit
import CoreData

fileprivate let tableName = "NearestAirports"
fileprivate let column_latitude = "latitude"
fileprivate let column_longitude = "longitude"
fileprivate let column_code = "code"
fileprivate let column_order = "order"

fileprivate struct OrderedCode {
    let order: Int
    let code: String
}

class NearestAirportsPersistence {
    lazy var context = AppPersistence.persistentContainer.viewContext
    
    func getNearestAirports(latitude: Double, longitude: Double) -> [String]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                NSPredicate(format: "\(column_latitude) == %f", Float(latitude)),
                NSPredicate(format: "\(column_longitude) == %f", Float(longitude))
            ]
        )
        do {
            if let results = try context.fetch(request) as? [NSManagedObject], results.count > 0 {
                var output = [OrderedCode]()
                for result in results {
                    output.append(OrderedCode(
                        order: result.value(forKey: column_order) as? Int ?? 0,
                        code: result.value(forKey: column_code) as? String ?? ""
                    ))
                }
                return output.sorted { $0.order < $1.order }.map { $0.code }
            }
        } catch {
            print("Airports could not be fetched because of an exception")
        }
        return nil
    }
    
    func saveNearestAirports(_ airports: [String], latitude: Double, longitude: Double) {
        for (index, airport) in airports.enumerated() {
            let object = NSEntityDescription.insertNewObject(forEntityName: tableName, into: context)
            object.setValue(index, forKey: column_order)
            object.setValue(airport, forKey: column_code)
            object.setValue(Float(latitude), forKey: column_latitude)
            object.setValue(Float(longitude), forKey: column_longitude)
            do {
                try context.save()
            } catch {
                print("Airport could not be saved because of an exception")
            }
        }
    }
}
