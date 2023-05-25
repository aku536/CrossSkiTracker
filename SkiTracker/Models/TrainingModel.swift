//
//  TrainingModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.05.2023.
//

import Foundation

struct TrainingModel {
  var trainingTime: Double
  var distance: Double
  var elevation: Double
  var maxSpeed: Double
}

extension TrainingModel {
  init() {
    self.init(trainingTime: 0, distance: 0, elevation: 0, maxSpeed: 0)
  }
}
