//
//  MapPickerView.swift
//  ToDoApp
//
//  Created by Kaitlyn Lee on 5/14/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedLocation: CLLocation?
    
    var userLocation: CLLocationCoordinate2D?  // New parameter
    
    @State private var region: MKCoordinateRegion

    init(selectedLocation: Binding<CLLocation?>, userLocation: CLLocationCoordinate2D?) {
        self._selectedLocation = selectedLocation
        self.userLocation = userLocation
        
        // Initialize region center based on selectedLocation or userLocation fallback
        let center = selectedLocation.wrappedValue?.coordinate ?? userLocation ?? CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090)
        
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        ZStack {
            Map(initialPosition: .region(region), interactionModes: .all)
                .mapControls {
                    MapUserLocationButton()
                }
                .onMapCameraChange { context in
                    region.center = context.region.center
                }
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
                .shadow(radius: 5)
            
            VStack {
                Spacer()
                Button("Pick This Location") {
                    selectedLocation = CLLocation(
                        latitude: region.center.latitude,
                        longitude: region.center.longitude
                    )
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom, 40)
            }
        }
    }
}
