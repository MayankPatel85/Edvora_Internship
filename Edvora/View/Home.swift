//
//  Home.swift
//  Edvora
//
//  Created by MΔΨΔΠҜ PΔTΣL on 10/06/22.
//

import SwiftUI

struct Home: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @State var selectedRide: Ride? = nil
    @State var selectedFeed: String = "Nearest"
    @State var selectedState: String = ""
    @State var selectedCity: String = ""
    @State var showDetail: Bool = false
    
    @Namespace var namespace
    
    let columns: [GridItem] = [GridItem(.flexible())]
    
    var feeds = ["Nearest", "Upcoming", "Past"]
    
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Edvora")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.top)
                            .padding(.leading)
                        Spacer()
                        if let user = homeViewModel.user {
                            AsyncImage(url: URL(string: user.url)!, content: { returnedImage in
                                returnedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 44)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            }, placeholder: {
                                ProgressView()
                                    .padding(.trailing)
                            })
                        }
                    }
                    
                    header
                    
                    if (!filteredRides.isEmpty) {
                        rideGrid
                    }
                    else {
                        Text("No rides to show.")
                    }
                }
                .zIndex(1)
            }
            
            if showDetail {
                if selectedRide != nil {
                    detailView
                }
            }
        }
        .onAppear {
            homeViewModel.getUser()
            homeViewModel.getRides()
        }
        
    }
    
    private var header: some View {
        HStack {
            ForEach(feeds, id: \.self) {feed in
                ZStack(alignment: .bottom) {
                    if selectedFeed == feed {
                        RoundedRectangle(cornerRadius: 14)
                            .matchedGeometryEffect(id: "feed", in: namespace)
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 5)
                            .offset(y: 10)
                    }
                    
                    Text(feed)
                        .fontWeight(selectedFeed == feed ? .bold : nil)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedFeed = feed
                    }
                }
            }
            Spacer()
            HStack {
                Image(systemName: "line.horizontal.3.decrease")
                Text("Filters")
            }
            .contextMenu {
                Menu {
                    ForEach(homeViewModel.rides) {ride in
                        Button {
                            selectedState = ride.state
                        } label: {
                            Text(ride.state)
                        }
                    }
                } label: {
                    Text("State")
                }
                Menu {
                    ForEach(cities, id: \.self) { city in
                        Button {
                            selectedCity = city
                        } label: {
                            Text(city)
                        }
                    }
                } label: {
                    Text("City")
                }
        }
        }
        .padding()
    }
    
    private var rideGrid: some View {
        LazyVGrid(columns: columns) {
            ForEach(filteredRides) { ride in
                ZStack(alignment: .bottomTrailing) {
                    
                    AsyncImage(url: URL(string: ride.mapURL)!, content: { returnedImage in
                        returnedImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .overlay {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("#")
                                        Text("\(ride.id)")
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(.blue)
                                        Text(ride.dateToString)
                                    }
                                    .padding()
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.regularMaterial)
                                }
                            }
                    }, placeholder: {
                        ProgressView()
                    })
                    
                    VStack {
                        Text("\(ride.distance ?? 0) km")
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.bottom, 58)
                            .padding(.trailing, 25)
                    }
                    
                }
                .onTapGesture {
                    withAnimation() {
                        showDetail.toggle()
                        selectedRide = ride
                    }
                }
                .cornerRadius(24)
                .padding()
            }
            .overlay(homeViewModel.isLoading ? ProgressView("LOADING") : nil)
        }
    }
    
    private var detailView: some View {
        VStack {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 5)
                
                AsyncImage(url: URL(string: selectedRide!.mapURL)!, content: { returnedImage in
                    returnedImage
                        .resizable()
                        .frame(height: 250)
                        .cornerRadius(24)
                }, placeholder: {
                    ProgressView()
                })
                
                VStack {
                    DetailField(header1: "Ride Id",  header2: "Origin Station",
                                data1: "\(selectedRide!.id)", data2: "\(selectedRide!.originStationCode)")
                    Divider()
                    DetailField(header1: "Date", header2: "Distance        ", data1: selectedRide!.dateToString, data2: "\(selectedRide!.distance ?? 0)")
                    Divider()
                    DetailField(header1: "State", header2: "City                ", data1: selectedRide!.state, data2: selectedRide!.city)
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Station Path")
                                .font(.caption)
                            Text(selectedRide!.stationpathString)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .onTapGesture {
            withAnimation {
                showDetail.toggle()
                selectedRide = nil
            }
        }
        .offset(y: UIScreen.main.bounds.height / 6)
        .zIndex(2)

    }
    
    var filteredRides: [Ride] {
        if selectedFeed == "Upcoming" {
            return homeViewModel.rides.filter {
                $0.toDate > Date()
            }
        } else if selectedFeed == "Past" {
            return homeViewModel.rides.filter {
                $0.toDate < Date()
            }
        } else if !selectedState.isEmpty {
            return homeViewModel.rides.filter {
                $0.state == selectedState
            }
        } else if !selectedCity.isEmpty {
            return homeViewModel.rides.filter {
                $0.city == selectedCity
            }
        } else {
            return homeViewModel.rides
        }
    }
    
    var cities: [String] {
        if !selectedState.isEmpty {
            return homeViewModel.rides.filter {
                $0.state == selectedState
            }.map {
                $0.city
            }
        } else {
            return homeViewModel.rides.map {
                $0.city
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(selectedRide: Ride(id: 1, originStationCode: 1, stationPath: [1,2,3], destinationStationCode: 2, date: "", mapURL: "", state: "", city: "", distance: 0))
    }
}

struct DetailField: View {
    let header1, header2: String
    let data1, data2: String
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(header1)
                    .font(.caption)
                Text(data1)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(header2)
                    .font(.caption)
                Text(data2)
            }
        }
    }
}
