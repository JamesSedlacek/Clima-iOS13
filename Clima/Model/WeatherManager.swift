//
//  WeatherManager.swift
//  Clima
//
//  Created by James Sedlacek on 12/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherManager {
    //API INFO//
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    let URLString: String = "https://api.openweathermap.org/data/2.5/weather?q=" //MUST BE https://
    var cityName: String = ""
    let appID: String = "&appid="
    let APIKey: String = "8e1682ee309ce1d5f8ff79abe3a5bcb7"
    
    var APICall: String {
        return URLString + cityName + appID + APIKey
    }
    
    func kelvinToImperial(temp: Double) -> Double {
        return (temp - 273.15) * 9/5 + 32
    }
    
    mutating func fetchWeather(cityName: String) {
        self.cityName = cityName
        performRequest(urlString: APICall)
    }
    
    func performRequest(urlString: String) {
        
        //create URL
        if let url = URL(string: urlString) {
            
            //Create URL Session
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in //closure
                
                //if there's an error, print the error and exit the function
                if let theError = error {
                    print(theError)
                    return
                }
                
                //if there is data parse it
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            })
            
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        } catch {
            print(error)
        }
    }
}
