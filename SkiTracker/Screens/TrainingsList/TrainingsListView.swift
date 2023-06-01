//
//  TrainingsListView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 01.06.2023.
//

import SwiftUI

struct TrainingsListView: View {

  @EnvironmentObject var viewModel: TrainingsListViewModel

  // MARK: - Body

  var body: some View {
    List(viewModel.savedTrainings) { training in
      HStack {
        Text("Тренировка на \(training.trainingTime)")
      }
    }
    .onAppear {
      viewModel.loadTrainings()
    }
  }

  // MARK: - Приватные свойства

}

// MARK: - PreviewProvider

struct TrainingsListView_Previews: PreviewProvider {
  static var previews: some View {
    TrainingsListView()
      .environment(\.locale, Locale(identifier: "ru_RU"))
      .environmentObject(TrainingsListViewModel(storageService: StorageService()))
  }
}
