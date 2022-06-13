//
//  Ride.swift
//  Edvora
//
//  Created by MΔΨΔΠҜ PΔTΣL on 10/06/22.
//

import Foundation

// MARK: - Ride Model
struct Ride: Codable, Identifiable {
    let id, originStationCode: Int
    var stationPath: [Int]
    let destinationStationCode: Int
    let date: String
    let mapURL: String
    let state, city: String
    var distance: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case originStationCode = "origin_station_code"
        case stationPath = "station_path"
        case destinationStationCode = "destination_station_code"
        case date
        case mapURL = "map_url"
        case state, city, distance
    }
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
        return dateFormatter.date(from: date)!
    }
    
    var dateToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d'th' MMM"
        return dateFormatter.string(from: toDate) 
    }
    
    var stationpathString: String {
        stationPath.map {
            String($0)
        }.joined(separator: ",")
    }
}
