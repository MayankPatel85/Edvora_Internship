//
//  User.swift
//  Edvora
//
//  Created by MΔΨΔΠҜ PΔTΣL on 10/06/22.
//

import Foundation

// MARK: - User Model
struct User: Codable {
    let stationCode: Int
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case stationCode = "station_code"
        case name, url
    }
}
