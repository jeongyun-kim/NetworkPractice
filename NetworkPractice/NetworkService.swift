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
    
    var url: String {
        switch self {
        case .kakaoAddress:
            return KakaoUrl.kakaoUrl
        case .openWeather:
            return WeatherUrl.currentWeatherUrl
        case .lotto:
            return LottoUrl.lottoUrl
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
