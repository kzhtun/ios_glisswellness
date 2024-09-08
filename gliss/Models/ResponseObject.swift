//
//  ObjRes.swift
//  gliss
//
//  Created by Kyaw Zin on 07/09/2024.
//

import Foundation

struct ResponseObject: Codable {
    var  responsemessage: String!
    var  status: String!
    var  token: String!
    var  user: User
}
