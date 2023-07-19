//
//  Int+Extensions.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 10.07.2023.
//

import Foundation

extension Int {
  var timeFormat: String {
    let seconds = self % 3600 % 60
    let minutes = self % 3600 / 60
    let hours = self / 3600
    let hoursString = hours > 0 ? hours.doubleSignedDigit + ":" : ""
    return hoursString + minutes.doubleSignedDigit + ":" + seconds.doubleSignedDigit
  }

  var doubleSignedDigit: String {
    (self / 10) > 0 ? "\(self)" : "0\(self)"
  }
}
