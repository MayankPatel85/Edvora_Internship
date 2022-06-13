//
//  HomeViewModel.swift
//  Edvora
//
//  Created by MΔΨΔΠҜ PΔTΣL on 10/06/22.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var rides: [Ride] = []
    @Published var user: User? = nil
    
    func downloadData(url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil , let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300
            else {
                print("Error downloading data.")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }
    
    func getRides() {
        isLoading = true
        guard let url = URL(string: "https://assessment.api.vweb.app/rides") else { return }
        downloadData(url: url) { data in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Ride].self, from: data)
                DispatchQueue.main.async { [self] in
                    self.rides = result
                    for index in 0..<rides.count {
                        rides[index].distance = abs(rides[index].stationPath.min(by: { abs($0 - (user?.stationCode ?? 0)) < abs($1 - (user?.stationCode ?? 0)) })! - (user?.stationCode ?? 0))
                    }
                    self.rides.sort(by: { abs(($0.stationPath[0] - (self.user?.stationCode ?? 0))) < abs(($1.stationPath[0] - (self.user?.stationCode ?? 0))) })
                }
            } catch {
                print("Error getting rides.")
            }
        }
        isLoading = false
    }
    
    func getUser() {
        guard let url = URL(string: "https://assessment.api.vweb.app/user") else { return }
        downloadData(url: url) { data in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(User.self, from: data)
                print(result)
                DispatchQueue.main.async {
                    self.user = result
                }
            } catch {
                print("Error getting user.")
            }
        }
    }
    
//    func sortRides() {
//        for index in 0..<rides.count {
//            rides[index].stationPath.sort {
//                ($0 - (user?.stationCode ?? 0)) < ($1 - (user?.stationCode ?? 0))
//            }
//        }
//        print(user?.stationCode ?? 0)
//        rides.sort(by: { ($0.stationPath[0] - (user?.stationCode ?? 0)) < ($1.stationPath[0] - (user?.stationCode ?? 0)) })
//        rides.forEach { ride in
//            print("Ride  \(ride.stationPath[0])")
//        }
//    }
    
    
}
