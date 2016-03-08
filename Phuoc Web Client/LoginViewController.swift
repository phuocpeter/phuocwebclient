//
//  ViewController.swift
//  Phuoc Web Client
//
//  Created by Tran Thai Phuoc on 2016-03-05.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            // Login tapped
            if (serverTextField.text!.isEmpty || usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
                displayAlert("Error", message: "Missing required field")
            } else {
                postToServer()
            }
        } else if indexPath.section == 2 && indexPath.row == 1 {
            // Register tapped
        }
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func serverDone(sender: AnyObject) {
        usernameTextField.becomeFirstResponder()
    }
    @IBAction func usernameDone(sender: AnyObject) {
        passwordTextField.becomeFirstResponder()
    }
    @IBAction func passwordDone(sender: AnyObject) {
        passwordTextField.endEditing(false)
    }
    
    // MARK: - Server connection Methods
    
    func postToServer() {
        let url = NSURL(string: "http://" + serverTextField.text! + "/userLogin.php")
        print(url!)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        // Specify which data to pass
        let postString = "name=\(usernameTextField.text!)&key=\(passwordTextField.text!)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, respone, error in
            if error != nil {
                // Error occurred
                print(error)
            }
            if let ddata = data {
                // Check if the host is connectable
                do {
                    print("JSON")
                    let json = try NSJSONSerialization.JSONObjectWithData(ddata, options: .MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        // Parse json
                        let status = parseJSON["status"] as? String
                        let message = parseJSON["message"] as? String
                        dispatch_async(dispatch_get_main_queue(), {
                            // Display alert from main thread
                            self.displayAlert(status!, message: message!)
                        })
                    }
                } catch let jsonErr as NSError {
                    // Error parsing json
                    print(jsonErr)
                }
            } else {
                print("Failed to connect to host")
                self.displayAlert("Error", message: "Failed to connect to host")
            }
        }
        task.resume()
    }
    
    // MARK: Helper Methods
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

