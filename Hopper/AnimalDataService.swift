//
//  AnimalDataService.swift
//  Hopper
//
//  Created by Grant Starkman on 2/5/24.
//

import Foundation
import AWSDynamoDB
import Combine


class AnimalDataService {
    var dynamoDBObjectMapper: AWSDynamoDBObjectMapper
    
    init() {
        self.dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    }
    
    func fetchAnimalData(completion: @escaping ([Animal]?) -> Void) {
        // Define the query expression here
        let queryExpression = AWSDynamoDBQueryExpression()
        
        // Assuming 'AnimalData' is a DynamoDB model class that you have defined in your project
        dynamoDBObjectMapper.query(AnimalData.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if let error = error {
                print("The request failed. Error: \(error)")
                completion(nil)
                return
            }
            
            if let animalDataArray = output?.items as? [AnimalData] {
                // Map your DynamoDB data model to your SwiftUI data model
                let animals = animalDataArray.map { animalData in
                    Animal(id: animalData.animalId, name: animalData.name, image: animalData.imageKey)
                }
                completion(animals)
            }
        }
    }
}
