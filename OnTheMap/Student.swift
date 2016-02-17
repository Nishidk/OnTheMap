//
//  Student.swift
//  OnTheMap
//
//  Created by Nishid Pai Kakode on 14/02/16.
//  Copyright © 2016 Nishid Pai Kakode. All rights reserved.
//

import UIKit

struct Student {
    
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.000
    var longitude = 0.000
    var mapString = ""
    var mediaURL = ""
    var objectId = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary["createdAt"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! String
        
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [Student] {
        
        var students = [Student]()
        
        /* Iterate through array of dictionaries*/
        for result in results {
            students.append(Student(dictionary: result))
        }
        
        return students
    }
    
    
}
