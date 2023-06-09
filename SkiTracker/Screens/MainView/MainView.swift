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

          stopButton
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
      Haptics.shared.notify(.success)
    }, label: {
      Text("Стоп")
        .foregroundColor(.white)
    })
    .frame(width: 50, height: 50)
    .background(.red)
    .cornerRadius(10)
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
    MainView().environment(\.locale, Locale(identifier: "ru_RU"))
  }
}
