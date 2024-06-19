//
//  Weather.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import Foundation

struct WeatherContainer: Decodable {
    let weather: [Weather]
    let main: Temperature
}

struct Weather: Decodable {
    let main: String
    let icon: String
    let description: String
    
    var desc: String {
        return "오늘의 날씨는 \(description)이네요 :)"
    }
}

struct Temperature: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
 
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
    
    var descCelsiusTemp: String {
        let tempMin = Int(round(tempMin - 273.15))
        let tempMax = Int(round(tempMax - 273.15))
        return "오늘의 최저 기온은 \(tempMin)℃, \n최고 기온은 \(tempMax)℃에요"
    }
    
    var descHumidity: String {
        return "그리고 \(humidity)%만큼 습해용"
    }
}

struct WeatherAndTemperature {
    let data: String
    var type: WeatherDataType = .text
}
