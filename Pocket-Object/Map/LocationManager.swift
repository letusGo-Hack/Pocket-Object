//
//  LocationManager.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  @Published var authorizationStatus: CLAuthorizationStatus?
  @Published var currentLocation = CLLocationCoordinate2D()
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      authorizationStatus = .authorizedWhenInUse
      locationManager.requestLocation()
      break
      
    case .restricted:
      authorizationStatus = .restricted
      break
      
    case .denied:
      authorizationStatus = .denied
      break
      
    case .notDetermined:
      authorizationStatus = .notDetermined
      manager.requestWhenInUseAuthorization()
      break
      
    default:
      break
    }
  }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 현재 위치 정보 업데이트
        currentLocation = location.coordinate
    }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("error: \(error.localizedDescription)")
  }
  
  func getCurrentLocation() {
//    Task() {
//      do {
//        let updates = CLLocationUpdate.liveUpdates()
//        for try await update in updates {
//          if let loc = update.location {
//            let cord = loc.coordinate
//            self.currentLocation = CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude)
//          }
//        }
//      } catch {
//        print(error.localizedDescription)
//      }
//      return
//    }
  }
  
  
}


