//
//  Haptics.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.05.2023.
//

import UIKit

class Haptics {
  static let shared = Haptics()

  private init() {}

  func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
  }

  func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
  }
}
