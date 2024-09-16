//
//  Router.swift
//  gliss
//
//  Created by Kyaw Zin on 06/09/2024.
//

import Foundation
import Alamofire


class Router{
    let App = UIApplication.shared.delegate as! AppDelegate
    static var instance: Router?
    

    static var  DEV = "http://118.200.70.54/RestAPISPA/R4AService.svc/"
    static var  LIVE = "https://spaapi.glissgroups.com/r4aservice.svc/"
    
    let baseURL = DEV
    
    static var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
    
    static func sharedInstance() -> Router {
        allowedQueryParamAndKey.remove(charactersIn: ";?@&=+$#")
        
        if self.instance == nil {
            self.instance = Router()
        }
        return self.instance!
    }
    
    
    func ValidateDevice( deviceid: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let url = String(format: "%@%@/%@", baseURL, "validatedevice", deviceid)
       
       AF.request(url, method: .get)
          .response{
             (response) in
              
              guard let data = response.data else{
                 print("ValidateDevice Success, No Data")
                 return
              }
              do{
                 let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
            
                success(objRes)
                
                print("ValidateDevice Success")
             }catch{
                failure("ValidateDevice Failed")
             }
          }
    }
    
    func ValidateUser( username: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let url = String(format: "%@%@/%@", baseURL, "validateuser", username)
       
       AF.request(url, method: .get)
          .response{
             (response) in
              
              guard let data = response.data else{
                 print("ValidateUser Success, No Data")
                 return
              }
              do{
                 let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
            
                success(objRes)
                
                print("ValidateUser Success")
             }catch{
                failure("ValidateUser Failed")
             }
          }
    }
 
    //@GET("sendotp/{username},{email}")
    func SendOTP( username: String, email: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let url = String(format: "%@%@/%@,%@", baseURL, "sendotp", username, email)
       
       AF.request(url, method: .get)
          .response{
             (response) in
              
              guard let data = response.data else{
                 print("SendOTP Success, No Data")
                 return
              }
              do{
                 let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
            
                success(objRes)
                
                print("SendOTP Success")
             }catch{
                failure("SendOTP Failed")
             }
          }
    }
    
    
    //@GET("updateuser/{username},{email},{mobile},{deviceid},{fcmtoken}")
    func UpdateUser( username: String, email: String, mobile: String, deviceid: String, fcmtoken: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let url = String(format: "%@%@/%@,%@,%@,%@,%@", baseURL, "updateuser", username, email, mobile, deviceid, fcmtoken)
       
       AF.request(url, method: .get)
          .response{
             (response) in
              
              guard let data = response.data else{
                 print("UpdateUser Success, No Data")
                 return
              }
              do{
                 let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
            
                success(objRes)
                
                print("UpdateUser Success")
             }catch{
                failure("UpdateUser Failed")
             }
          }
    }
    
    //@GET("saveattendance/{cocode},{branchid},{branchcode},{staffid},{staffname},{checktype},{location},{remarks}")
    func SaveAttendance( cocode: String, branchid: String, branchcode: String, staffid: String, staffname: String,checktype: String,location: String,remarks: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
    
        let parameters: [String: Any] = [
            "cocode" : cocode,
            "branchid" : branchid,
            "branchcode" : branchcode,
            "staffid" : staffid,
            "staffname" : staffname,
            "checktype" : checktype,
            "location": location,
            "remarks": remarks
            ]
        
       let url = String(format: "%@%@", baseURL, "saveattendance")
       
       AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
          .response{
             (response) in
              
              guard let data = response.data else{
                 print("SaveAttendance Success, No Data")
                 return
              }
              do{
                 let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
            
                success(objRes)
                
                print("SaveAttendance Success")
             }catch{
                failure("SaveAttendance Failed")
             }
          }
    }
}
