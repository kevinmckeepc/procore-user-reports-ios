//
//  UserReport.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import Foundation

struct UserReport: JSONDocument {
    
    var documentID: String?
    var login: String?
    var userID: Int64?
    
    enum CodingKeys: String, CodingKey {
        case telemetry
    }
    
    enum TelemetryCodingKeys: String, CodingKey {
        case userContextManager
    }
    
    enum UserContextManagerCodingKeys: String, CodingKey {
        case current
    }
    
    enum CurrentCodingKeys: String, CodingKey {
        case key
    }
    
    enum UserKeysCodingKeys: String, CodingKey {
        case login
        case userID
    }
    
    static func collection() -> String { return "user-reports" }
    
    init(from decoder: Decoder) throws {
        
        // Top level container values
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Telemetry container
        let telemetryContainer = try values.nestedContainer(keyedBy: TelemetryCodingKeys.self, forKey: .telemetry)
        
        // User Context Manager container
        let userContextManagerContainer = try telemetryContainer.nestedContainer(keyedBy: UserContextManagerCodingKeys.self, forKey: .userContextManager)

        // Current Container
        let currentContainer = try userContextManagerContainer.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)

        // User Keys Container
        let userKeysContainer = try currentContainer.nestedContainer(keyedBy: UserKeysCodingKeys.self, forKey: .key)
        
        login = try userKeysContainer.decodeIfPresent(String.self, forKey: .login)
        userID = try userKeysContainer.decodeIfPresent(Int64.self, forKey: .userID)
    }
    
    
    func encode(to encoder: Encoder) throws { }

}
