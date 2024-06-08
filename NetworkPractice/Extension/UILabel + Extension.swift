//
//  UILabel + Extension.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import UIKit

extension UILabel {
    func configureLottoLabel(_ type: BallType = .ball) {
        switch type {
        case .ball:
            self.backgroundColor = .lightGray
            self.clipsToBounds = true
            self.layer.cornerRadius = 20
            self.textAlignment = .center
            self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            self.textColor = .white
            self.text = ""
        case .plus:
            self.text = "+"
            self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            self.textColor = .darkGray
            self.textAlignment = .center
        }
    }
    
    func configureFont(_ text: String = "", size: CGFloat, weight: UIFont.Weight = .regular) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

