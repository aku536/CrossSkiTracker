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
    switch viewModel.state {
    case .notRunning:
      startButton
    case .active, .finished:
      TabView {

        NavigationView {
          VStack {

            VStack {
              timerLabel
              distanceLabel
              elivationLabel
              speedLabel
            }
            .font(.largeTitle)
            .padding()

            NavigationLink(destination: {
              viewModel.didTapMapOpen()
            }, label: {
              Text("Открыть карту")
            })

            switch viewModel.state {
            case .active:
              stopButton
            case .finished:
              endButtons
            default:
              Spacer()
            }
          }
        }
        .tabItem {
          Label("Тренировка", systemImage: "tray.and.arrow.down.fill")
        }

        TrainingsListView()
          .tabItem {
            Label("Список", systemImage: "tray.and.arrow.down.fill")
          }

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

  private var stopButton: some View {
    Button(action: {
      viewModel.state.toggle()
      Haptics.shared.notify(.warning)
    }, label: {
      Text("Стоп")
        .foregroundColor(.white)
    })
    .frame(width: 50, height: 50)
    .background(.red)
    .cornerRadius(10)
  }

  private var endButtons: some View {
    VStack {
      Button(action: {
        viewModel.saveTraining()
        Haptics.shared.notify(.success)
        viewModel.state.toggle()
      }, label: {
        Text("Сохранить")
          .foregroundColor(.white)
      })
      .background(.green)
      .frame(width: 150, height: 50)
      .cornerRadius(10)

      Spacer()

      Button(action: {
        viewModel.state.toggle()
        Haptics.shared.notify(.error)
      }, label: {
        Text("Сбросить")
          .foregroundColor(.white)
      })
      .background(.red)
      .frame(width: 150, height: 50)
      .cornerRadius(10)
    }
  }

  private var timerLabel: some View {
    VStack {
      Text(viewModel.trainingTime, style: .timer)
      Text("Время")
        .font(.body)
    }
  }

  private var distanceLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.distance, unit: UnitLength.kilometers) ,
           format: .measurement(width: .abbreviated, usage: .asProvided))
      Text("Расстояние")
        .font(.body)
    }
  }

  private var elivationLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.elevation, unit: UnitLength.meters), format: .measurement(width: .abbreviated,
                                                     usage: .asProvided,
                                                     numberFormatStyle: .number))
      Text("Перепад высот")
        .font(.body)
    }
  }

  private var speedLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.maxSpeed, unit: UnitSpeed.kilometersPerHour) , format: .measurement(width: .abbreviated,
                                                    usage: .asProvided,
                                                                  numberFormatStyle: .number))
      Text("Максимальная скорость")
        .font(.body)
    }
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
