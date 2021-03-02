//
//  UIAplication+Extension.swift
//  Tenki App
//
//  Created by ethancr0wn on 2021/03/02.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
