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
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
 
    var descCelsiusTemp: String {
        let tempMin = Int(round(temp_min - 273.15))
        let tempMax = Int(round(temp_max - 273.15))
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

//WeatherContainer(weather: [NetworkPractice.Weather(main: "Clouds", icon: "02d", description: "약간의 구름이 낀 하늘")], main: NetworkPractice.Temperature(temp: 300.79, feels_like: 301.54, temp_min: 294.84, temp_max: 303.81))
