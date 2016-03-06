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
    }

    // MARK: - IBAction Methods
    
    @IBAction func login() {
        postToServer()

    }
    
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
        let url = NSURL(string: "http://192.168.1.2")
        let request = NSMutableURLRequest(URL: url!)
        let username = "name=\(usernameTextField.text)"
        let password = "key=\(passwordTextField.text)"
        request.HTTPMethod = "POST"
        request.HTTPBody = username.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = password.dataUsingEncoding(NSUTF8StringEncoding)
        print("Posted")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, data, error) in print(response, error)})
    }

}

