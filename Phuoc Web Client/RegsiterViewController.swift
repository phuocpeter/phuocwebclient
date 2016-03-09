//
//  RegsiterViewController.swift
//  Phuoc Web Client
//
//  Created by Tran Thai Phuoc on 2016-03-08.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit

class RegsiterViewController: UITableViewController {

    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var pass2: UITextField!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate methods

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            // Register tapped
            if serverTextField.text!.isEmpty || usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || pass2.text!.isEmpty {
                // If one of the required field are empty
                self.displayAlert("Error", message: "Missing required field")
            } else if let pass = passwordTextField.text {
                if pass.characters.count < 4 {
                    // Check if password too short
                    self.displayAlert("Error", message: "Password must be longer than 3 characters")
                } else if pass2.text! != passwordTextField.text! {
                    // Check if the two password fields are matched
                    self.displayAlert("Error", message: "Password does not match")
                } else {
                    // No error
                    print("Post")
                    postToServer()
                }

            }
        }
    }

    // MARK: - IBAction Methods

    @IBAction func cancel() {
        // Dismiss this register view
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func serverDone() {
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func usernameDone() {
        passwordTextField.becomeFirstResponder()
    }

    @IBAction func passwordDone() {
        pass2.becomeFirstResponder()
    }

    @IBAction func password2() {
        pass2.endEditing(false)
    }

    // MARK: - Helper Methods

    func postToServer() {
        // Construct the post url
        let url = NSURL(string: "http://" + serverTextField.text! + "/userRegister.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        let postString = "name=\(usernameTextField.text!)&key=\(passwordTextField.text!)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        // Create task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print(error)
            }
            if let ddata = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(ddata, options: .MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        // Connected to the server and received data
                        let status = parseJSON["status"] as! String
                        let message = parseJSON["message"] as! String
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayAlert(status, message: message)
                        })
                    }
                } catch let jsonErr as NSError {
                    print(jsonErr)
                }
            } else {
                // Cannot connect nor receive data
                dispatch_async(dispatch_get_main_queue(), {
                    self.displayAlert("Error", message: "Failed to connect to host")
                })
            }
        }
        task.resume()
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
