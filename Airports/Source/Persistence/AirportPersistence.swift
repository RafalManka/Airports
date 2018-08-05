//
//  AirportPersistence.swift
//  EmiratesBooking
//
//  Created by rafal.manka on 23/07/2018.
//  Copyright © 2018 Emirates Airlines. All rights reserved.
//

import UIKit
import CoreData

fileprivate let tableName = "Airports"
fileprivate let column_code = "code"
fileprivate let column_name = "name"
fileprivate let column_city = "city"
fileprivate let column_country = "country"

fileprivate let dbName = "Booking"

class AppPersistence {
    static let persistentContainer: NSPersistentContainer = {
        let url = Bundle(for: AppPersistence.self).url(forResource: dbName, withExtension: "momd")!
        let container = NSPersistentContainer(name: dbName, managedObjectModel: NSManagedObjectModel(contentsOf: url)!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}


class AirportPersistence {
    lazy var context = AppPersistence.persistentContainer.viewContext
    
    var airports: [Airport]? {
        get {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            request.returnsObjectsAsFaults = false
            do {
                if let results = try context.fetch(request) as? [NSManagedObject], results.count > 0 {
                    var output = [Airport]()
                    for result in results {
                        output.append(Airport(
                            code: result.value(forKey: column_code) as? String ?? "",
                            name: result.value(forKey: column_name) as? String ?? "",
                            city: result.value(forKey: column_city) as? String ?? "",
                            country: result.value(forKey: column_country) as? String ?? ""
                        ))
                    }
                    return output
                }
            } catch {
                print("Airports could not be fetched because of an exception")
            }
            return nil
        }
        set(newValue) {
            guard let airports = newValue else { return }
            for airport in airports {
                let object = NSEntityDescription.insertNewObject(forEntityName: tableName, into: context)
                object.setValue(airport.code, forKey: column_code)
                object.setValue(airport.name, forKey: column_name)
                object.setValue(airport.city, forKey: column_city)
                object.setValue(airport.country, forKey: column_country)
                do {
                    try context.save()
                } catch {
                    print("Airport could not be saved because of an exception")
                }
            }
        }
    }
}
