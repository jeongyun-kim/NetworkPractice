//
//  ValidateDateErrorCase.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/22/24.
//

import Foundation

enum ValidateDateErrorCase: String, Error {
    case emptyString = "검색할 날짜를 입력해주세요" // 문자열이 빈 경우
    case notNumber = "숫자로만 입력해주세요" // 숫자를 안 넣은 경우
    case wrongLength = "날짜 형식에 맞춰 입력해주세요" // 문자 길이가 8자가 아닌 경우
    case futureDate = "검색 가능한 날짜를 입력해주세요" // 입력한 날짜가 미래인 경우
    case emptyData = "불러올 데이터가 없어요" // 불러올 데이터가 없는 경우
}
