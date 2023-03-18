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
  var startLocation: CLLocation!
  var lastLocation: CLLocation!
  var traveledDistance: Double = 0

  override init() {
    super.init()
    Task {
      await startLocate()
    }

  }

  private func startLocate() async {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
      locationManager.startMonitoringSignificantLocationChanges()
      locationManager.distanceFilter = 100
    }
  }

  func getDistance() -> Double {
    traveledDistance
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if startLocation == nil {
      startLocation = locations.first
    } else if let location = locations.last {
      traveledDistance += lastLocation.distance(from: location)
      print("Traveled Distance:",  traveledDistance)
      print("Straight Distance:", startLocation.distance(from: locations.last!))
    }
    lastLocation = locations.last
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if (error as? CLError)?.code == .denied {
      manager.stopUpdatingLocation()
      manager.stopMonitoringSignificantLocationChanges()
    }
  }
}
