//
//  WeatherModel.swift
//  Clima
//
//  Created by James Sedlacek on 12/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var imperialTemp: Double {
        return kelvinToImperial(temp: temperature)
    }
    
    func kelvinToImperial(temp: Double) -> Double {
        return (temp - 273.15) * 9/5 + 32
    }
    
    var temperatureString: String {
        return String(format: "%.1f", imperialTemp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
