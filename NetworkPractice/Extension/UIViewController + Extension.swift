//
//  UIViewController + Extension.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import UIKit
import Toast

extension UIViewController {
    func showToast(_ message: String) {
        self.view.makeToast(message, duration: 1, position: .bottom)
    }
}
