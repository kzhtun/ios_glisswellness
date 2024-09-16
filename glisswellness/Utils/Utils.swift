//
//  Utils.swift
//  gliss
//
//  Created by Kyaw Zin on 07/09/2024.
//

import Foundation
import UIKit
import Alamofire

func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
}


func getDeviceID()->String{
   if let uuid = UIDevice.current.identifierForVendor?.uuidString{
      return uuid
   }
   return ""
}

func covertDateToString(date: Date, formatString: String)->String{
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = formatString
   
   return dateFormatter.string(from: date)
}

func getCurrentDateTimeString(formatString: String)->String{
   let currentDate = Date()
   
   let dateFormatter = DateFormatter()
   dateFormatter.timeZone = .some(TimeZone(abbreviation: "UTC+08")!)
   
   dateFormatter.dateFormat = formatString
   
   return dateFormatter.string(from: currentDate)
}

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
