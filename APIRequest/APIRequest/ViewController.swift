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
let url = "http://challenge.code2040.org/api"

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
        textView.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func register(_ sender: UIButton) {
        let params = ["token": token,
                      "github": github]
        self.task(endpoint: "/register", method: "POST", params: params as [String : AnyObject]) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.clearTextField()
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
    }
    
    @IBAction func reverse(_ sender: UIButton) {
        self.task(endpoint: "/reverse", method: "POST", params: ["token": token as AnyObject]) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.clearTextField()
                let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                self.updateTextField(string: string)
                self.reverseString(string: string)
            }
        }
    }
    
    @IBAction func needle(_ sender: UIButton) {
        self.task(endpoint: "/haystack", method: "POST", params: ["token": token as AnyObject]) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.clearTextField()
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                self.updateTextField(string: json?["needle"] as! String)
                self.needle(needle: json?["needle"] as! String, haystack: json?["haystack"] as! [String])
            }
        }
    }

    @IBAction func prefix(_ sender: UIButton) {
        self.task(endpoint: "/prefix", method: "POST", params: ["token": token as AnyObject]) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.clearTextField()
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                self.updateTextField(string: json?["prefix"] as! String)
                self.prefix(prefix: json?["prefix"] as! String, array: json?["array"] as! [String])
            }
        }
    }
    
    @IBAction func date(_ sender: UIButton) {
        self.task(endpoint: "/dating", method: "POST", params: ["token": token as AnyObject]) { (data, response, error) in
            if error != nil {
                self.updateTextField(string: error.debugDescription)
            } else if response != nil {
                // self.updateTextField(string: response.debugDescription)
            }
            
            if data != nil {
                self.clearTextField()
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                self.updateTextField(string: json?["datestamp"] as! String)
                self.dating(datestamp: json?["datestamp"] as! String, interval: json?["interval"] as! Double)
            }
        }
    }
    
    func clearTextField() {
        DispatchQueue.main.async {
            self.textView.text = ""
        }
    }
    
    func updateTextField(string: String) {
        DispatchQueue.main.async { 
            self.textView.text = self.textView.text + string
        }
    }
    
    func reverseString(string: String) {
        let reverse = String(string.characters.reversed())
        let params = ["token": token,
                      "string": reverse]
        self.task(endpoint: "/reverse/validate", method: "POST", params: params as [String : AnyObject]) { (data, response, error) in
            if data != nil {
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
    }
    
    func needle(needle: String, haystack: [String]) {
        var count = 0
        for string in haystack {
            if string == needle {
                break
            }
            count += 1
        }
        let params = ["token": token,
                      "needle": count] as [String : Any]
        self.task(endpoint: "/haystack/validate", method: "POST", params: params as [String : AnyObject]) { (data, response, error) in
            if data != nil {
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
    }
    
    func prefix(prefix: String, array: [String]) {
        var outputArray = [String]()
        for string in array {
            if !string.hasPrefix(prefix) {
                outputArray.append(string)
            }
        }
        let params = ["token": token,
                      "array": outputArray] as [String : Any]
        self.task(endpoint: "/prefix/validate", method: "POST", params: params as [String : AnyObject]) { (data, response, error) in
            if data != nil {
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
    }
    
    func dating(datestamp: String, interval: Double) {
        var date = datestamp.dateFromISO8601!
        date.addTimeInterval(TimeInterval(interval))
        let datestampnow = date.iso8601
        let params = ["token": token,
                      "datestamp": datestampnow] as [String : Any]
        self.task(endpoint: "/dating/validate", method: "POST", params: params as [String : AnyObject]) { (data, response, error) in
            if data != nil {
                self.updateTextField(string: NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String)
            }
        }
    }

    private func task(endpoint: String, method: String, params: [String: AnyObject], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: url + endpoint)!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        let task = session.dataTask(with: request) { (data, response, error) in completionHandler(data, response, error) }
        task.resume()
    }
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}
