//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nishid Pai Kakode on 11/02/16.
//  Copyright © 2016 Nishid Pai Kakode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameLabelText: UITextField!
    @IBOutlet weak var passwordLabelText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonClick(sender: AnyObject) {
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameLabelText.text!)\", \"password\": \"\(passwordLabelText.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                self.showErrorAlert("Connection Error. Please retry.")
                //print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 403 {
                        self.showErrorAlert("Incorrect Username or Password")
                    }
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard (parsedResult.objectForKey("session") == nil)
                else {
                    //print("Login Successful")
                    //return
                    dispatch_async(dispatch_get_main_queue()) {
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapTabBarController") as! UITabBarController
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                    return
                    }

        }
        task.resume()
    }
    
    func showErrorAlert(message: String)
    {
        dispatch_async(dispatch_get_main_queue()){
            let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

}

