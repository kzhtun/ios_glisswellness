//
//  UITextFieldExt.swift
//  gliss
//
//  Created by Kyaw Zin on 08/09/2024.
//

import Foundation
import UIKit

extension UITextField{
   func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension Bundle {
    class var applicationName: String {

        if let displayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name: String = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return "No Name Found"
    }
}

extension UIButton{
    func addTextSpacing(_ spacing: CGFloat){
       let attributedString = NSMutableAttributedString(string: title(for: .normal) ?? "")
       attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.string.count))
       self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setEnabled(enabled: Bool){
        if enabled{
            self.isUserInteractionEnabled = true
            self.setTitleColor(UIColor.white,for: .normal)
        }else{
            self.isUserInteractionEnabled = false
            self.setTitleColor(UIColor.black,for: .normal)
        }
            
    }
    
}

extension String{
   var replaceEscapeChr: String{
   var addr: String
       addr = self.replacingOccurrences(of: " ", with: "_")
       addr = addr.replacingOccurrences(of: ",", with: "_")
       addr = addr.replacingOccurrences(of: "__", with: "_")
      return addr
   }
}

extension StringProtocol where Index == String.Index {
    func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

