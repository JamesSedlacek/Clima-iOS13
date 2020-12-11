//
//  WeatherManager.swift
//  Clima
//
//  Created by James Sedlacek on 12/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8e1682ee309ce1d5f8ff79abe3a5bcb7"
    
    func fetchWeather(cityName: String) {
        // api.openweathermap.org/data/2.5/weather?appid={API key}&q={city name}
        let urlString = weatherURL + "&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = weatherURL + "&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //create URL
        if let url = URL(string: urlString) {
            
            //Create URL Session
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in //closure
                
                //if there's an error, print the error and exit the function
                if let theError = error {
                    self.delegate?.didFailWithError(error: theError)
                    //print(theError)
                    return
                }
                
                //if there is data parse the JSON
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            })
            
            //Start the task
            task.resume()
        }
    }
    
    //If you can decode the weatherData, then
    //create a WeatherModel object and return it
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            self.delegate?.didFailWithError(error: error)
            //print(error)
            return nil
        }
        
    }
}
