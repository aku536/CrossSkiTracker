//
//  ContentView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import SwiftUI

struct MainView: View {

  @EnvironmentObject var viewModel: MainViewModel

  // MARK: - Body

  var body: some View {
    TabView {

      switch viewModel.state {
      case .notRunning:
        startButton
          .tabItem {
            Label("Тренировка", systemImage: "tray.and.arrow.down.fill")
          }

      case .active, .finished:
        TrainingProgressView()
        .tabItem {
          Label("Тренировка", systemImage: "tray.and.arrow.down.fill")
        }
      }

      TrainingsListView()
        .tabItem {
          Label("Список", systemImage: "tray.and.arrow.down.fill")
        }
    }
  }

  // MARK: - Приватные свойства

  private var startButton: some View {
    Button(action: {
      viewModel.state = .active
      Haptics.shared.play(.heavy)
    }, label: {
      Text("Старт")
        .foregroundColor(.white)
    })
    .frame(width: 100, height: 100)
    .background(.green)
    .cornerRadius(100/2)
  }
}

// MARK: - PreviewProvider

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
      .environment(\.locale, Locale(identifier: "ru_RU"))
      .environmentObject(
        MainViewModel(
          trainingModel: TrainingModel(),
          locationService: LocationService(),
          storageService: StorageService()
        )
      )
  }
}
