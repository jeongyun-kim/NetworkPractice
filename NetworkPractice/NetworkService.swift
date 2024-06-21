//
//  NetworkService.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/20/24.
//

import Foundation
import Alamofire

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

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    func fetch<T: Decodable>(NetworkCase: NetworkCase, params: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (T) -> Void) {
        AF.request(NetworkCase.url, parameters: params, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension NetworkService {
    func fetchLottoData(handler: @escaping (Lotto) -> Void) {
        fetch(NetworkCase: .lotto, params: nil, headers: nil) { result in
            handler(result)
        }
    }
    
    func fetchWeatherData(x: Double, y: Double, handler: @escaping (WeatherContainer) -> Void) {
        let params: Parameters = ["lon": x, "lat": y, "appid": APIKeys.weatherKey, "lang": "kr"]
        fetch(NetworkCase: .openWeather, params: params, headers: nil) { result in
            handler(result)
        }
    }
    
    func fetchAddressData(x: Double, y: Double, handler: @escaping (AddressContainer) -> Void) {
        let params: Parameters = ["x": x, "y": y]
        fetch(NetworkCase: .kakaoAddress, params: params, headers: KakaoUrl.kakaoHeaders) { result in
            handler(result)
        }
    }
    
    func fetchMovieData(handler: @escaping (BoxOffice) -> Void) {
        fetch(NetworkCase: .movie, params: nil, headers: nil) { result in
            handler(result)
        }
    }
}
