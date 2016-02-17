//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Nishid Pai Kakode on 14/02/16.
//  Copyright © 2016 Nishid Pai Kakode. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    var students: [Student] = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did TheMovieDB return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                print("TheMovieDB returned an error. See the status_code and status_message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let results = parsedResult["results"] as? [[String : AnyObject]] else {
                print("Cannot find key 'results' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            //print(results)
            self.students = Student.studentsFromResults(results)
            //print(self.students)
        }
        task.resume()
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentDisplayCell")! as UITableViewCell
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.imageView?.image = UIImage(named: "Pin")
        return cell
    }


}
