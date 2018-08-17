//
//  JSONDocument.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import Foundation

enum JSONDocumentChangeType {
    case added
    case removed
    case modified
}

protocol JSONDocument: Codable {
    
    // Returns the collection path in the json data store
    static func collection() -> String
}
