//
//  NetworkCase.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/22/24.
//

import Foundation

enum NetworkCase {
    case kakaoAddress
    case openWeather
    case lotto
    case movie
    
    var url: String {
        switch self {
        case .kakaoAddress:
            return KakaoUrl.kakaoUrl
        case .openWeather:
            return WeatherUrl.currentWeatherUrl
        case .lotto:
            return LottoUrl.lottoUrl
        case .movie:
            return MovieUrl.movieUrl
        }
    }
}
