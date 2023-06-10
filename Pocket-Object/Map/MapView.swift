//
//  MapView.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import SwiftUI
import MapKit

struct MapView: View {
  @StateObject var locationDataManager = LocationDataManager()
  @StateObject var test = Test()
  @Namespace private var mapScope
  var body: some View {
    Map(scope: mapScope) {
      UserAnnotation()
    }
    .overlay(alignment: .bottomTrailing) {
      VStack {
        MapCompass(scope: mapScope)
        MapPitchButton(scope: mapScope)
        MapUserLocationButton(scope: mapScope)
      }
      .buttonBorderShape(.circle)
      .padding()
    }
    .mapScope(mapScope)
    .onAppear {
      locationDataManager.getCurrentLocation()
    }
  }
}

#Preview {
  MapView()
}


class Test: ObservableObject {
//  let testModel: MKMapItem = MKMapItem(placemark: MKPlacemark(
//    coordinate: CLLocationCoordinate2D(latitude: 37.51165285847918, longitude: 127.05760549475231),
//    addressDictionary: [
//      "Title": "abcde",
//      "Date": 30
//    ])
//  )
  let testModel: MKMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.51165285847918, longitude: 127.05760549475231)))
  
  init() {
    testModel.name = "aaa"
  }
}
