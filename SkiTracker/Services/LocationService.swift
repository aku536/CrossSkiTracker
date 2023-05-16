//
//  LocationService.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import CoreLocation
import Foundation

final class LocationService: NSObject {

  let locationManager = CLLocationManager()
  var startLocation: CLLocation?
  var previousLocation: CLLocation?
  var traveledDistance: Double = 0
  var route: [CLLocation] = []

  var elevation: CLLocationDistance {
    guard !route.isEmpty else { return 0 }
    let sortedByAltitude = route.sorted(by: { $0.altitude > $1.altitude })
    return sortedByAltitude.first!.altitude - sortedByAltitude.last!.altitude
  }

  func startLocating() async {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
    }
  }

  func stopLocating() {
    locationManager.stopUpdatingLocation()
    startLocation = nil
  }

  func getDistance() -> Double {
    traveledDistance
  }

  func getRoute() -> [CLLocation] {
    route
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    route += locations
    guard startLocation != nil else {
      startLocation = locations.first
      return
    }
    if let lastLocation = locations.last {
      traveledDistance += previousLocation?.distance(from: lastLocation) ?? 0
    }
    previousLocation = locations.last
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if (error as? CLError)?.code == .denied {
      manager.stopUpdatingLocation()
    }
  }
}
