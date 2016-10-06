//
//  ViewController.swift
//  APIRequest
//
//  Created by Cindy Onyekwelu on 10/5/16.
//  Copyright © 2016 cindy. All rights reserved.
//

import UIKit

let token = "aa33f1a17bfebe415dea93cd5130b3d8"
let github = "https://github.com/CindyOnyekwelu/APIRequest"
let url = "http://challenge.code2040.org/api/register"

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func register(_ sender: UIButton) {
        let session = URLSession.shared
        
        let params = ["token": token,
                      "github": github]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
        
        task.resume()
    }
    
    func updateTextField(string: String) {
        DispatchQueue.main.async { 
            self.textView.text = self.textView.text + string
        }
    }

}

