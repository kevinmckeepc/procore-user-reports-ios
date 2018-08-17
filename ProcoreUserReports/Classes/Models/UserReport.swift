//
//  UserReport.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import Foundation

struct UserReport: JSONDocument {
    
    var email: String?
    
    enum CodingKeys: String, CodingKey {
//        case telemetry
//        case userContextManager
        case email
    }
    
    static func collection() -> String { return "user-reports" }
}
