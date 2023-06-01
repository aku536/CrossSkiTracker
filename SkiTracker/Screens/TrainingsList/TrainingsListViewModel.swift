//
//  TrainingsListViewModel.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 01.06.2023.
//

import Combine
import Foundation

@MainActor
final class TrainingsListViewModel: ObservableObject, Identifiable {

  @Published var savedTrainings: [TrainingModel] = []

  func loadTrainings() {
    savedTrainings = storageService.loadTrainings()
  }

  init(storageService: StorageService) {
    self.storageService = storageService
  }

  private let storageService: StorageService

  private var cancellable: Set<AnyCancellable> = []
}
