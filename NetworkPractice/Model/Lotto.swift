//
//  Lotto.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import Foundation

struct Lotto: Decodable {
    let drwNoDate: String
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    let drwNo: Int
    
    static var LottoDates: [String] {
        let timeInterval: TimeInterval = 32400
        
        let nowDate = Date().addingTimeInterval(timeInterval) // 지금 날짜

        let calendar = Calendar.current
        // 로또 기록이 있는 시작 날짜
        // 2002-12-07
        var components = DateComponents()
        components.day = 7
        components.month = 12
        components.year = 2002
        let startDate = calendar.date(from: components)?.addingTimeInterval(timeInterval)

        // 지금으로부터 로또 기록 시작 시점까지의 일 차이 구하기
        components = calendar.dateComponents([.day], from: startDate!, to: nowDate)
        
        // 일주일에 한 번 있으니까 7로 나눠주고 + 1
        let result = components.day! / 7 + 1
        // 반복문 돌면서 현재까지의 횟수 담아주기
        // - reversed : 큰 수부터 작은 수로 
        let list = (1...result).reversed().map { "\($0)"}
        
        return list
    }

    var resultDesc: String {
        return "\(drwNo)회"
    }
    
    var drwNoDesc: String {
        return "\(drwNoDate)회 추첨"
    }
}
