//
//  CodableExtensions.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

extension Decodable {
    
    init(json: JSON) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        self = try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    
    func toJSON() -> JSON {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(self)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else {
                return [:]
            }
            return json
        } catch { }
        return [:]
    }
}
