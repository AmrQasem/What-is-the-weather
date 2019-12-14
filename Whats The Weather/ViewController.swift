//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Clicks Egypt on 11/12/19.
//  Copyright © 2019 Clicks Egypt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weatherText: UITextField!
    
    @IBOutlet weak var weatherResult: UILabel!
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        if weatherText.text != "" {
            
            
            var userEntered = weatherText.text ?? "cairo"
            userEntered = userEntered.lowercased()
            
            if userEntered.contains(" ") {
                userEntered = userEntered.replacingOccurrences(of: " ", with: "-")
            }
            
            var mainURL = "https://www.weather-forecast.com/locations/" + userEntered + "/forecasts/latest"
            
            if let url = URL(string: mainURL){
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                var message = ""
                
                if error != nil {
                    print(error)
                } else{
                    
                    if let unrappedData = data {
                        
                        let dataString = NSString(data: unrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "Weather Today</h2> (1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                }
                                
                            }
                        }
                    }
                }
                
                if message == "" {
                    
                    message = "The weather couldn't be found. Please try again."
                    
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.weatherResult.text = message
                    
                })
            }
            
                task.resume()
                
            } else{
            weatherResult.text = "The weather couldn't be found. Please try again."
            }
            
        } else {
            weatherResult.text = "The weather couldn't be found. Please try again."
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.weatherText.delegate = self

            
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherText.resignFirstResponder()
        return true
    }
    
    


}

