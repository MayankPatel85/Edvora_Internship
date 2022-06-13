//
//  PreviewProvider.swift
//  Edvora
//
//  Created by MΔΨΔΠҜ PΔTΣL on 12/06/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let user = User(stationCode: 94, name: "Roth Ray", url: "https://picsum.photos/200")
    
    let rides = [
        Ride(id: 480, originStationCode: 6, stationPath: [51, 60 ,76, 88], destinationStationCode: 99, date: "03/26/2022 03:13 AM", mapURL: "https://picsum.photos/200", state: "West Bangal", city: "Adra"),
        Ride(id: 299, originStationCode: 19, stationPath: [36, 40, 57, 66 , 75, 86], destinationStationCode: 99, date: "03/19/2022 07:28 PM", mapURL: "https://picsum.photos/200", state: "Puducherry", city: "Puducherry"),
        Ride(id: 791, originStationCode: 18, stationPath: [39, 45, 57, 61, 70, 89], destinationStationCode: 97, date: "04/05/2022 02:07 AM", mapURL: "https://picsum.photos/200", state: "Chandigarh", city: "Chandigarh"),
        Ride(id: 266, originStationCode: 18, stationPath: [22, 32, 43, 54, 67, 74, 89], destinationStationCode: 95, date: "02/08/2022 07:10 PM", mapURL: "https://picsum.photos/200", state: "Manipur", city: "Mayang Imphal")
    ]
}
