//
//  TrainingProgressView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 10.07.2023.
//

import SwiftUI

struct TrainingProgressView: View {

  @EnvironmentObject var viewModel: MainViewModel

  var body: some View {
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
  }
}

private extension TrainingProgressView {
  var timerLabel: some View {
    VStack {
      Text(viewModel.trainingTime, style: .timer)
      Text("Время")
        .font(.body)
    }
  }

  var distanceLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.distance, unit: UnitLength.kilometers),
           format: .measurement(width: .abbreviated, usage: .asProvided))
      Text("Расстояние")
        .font(.body)
    }
  }

  var elivationLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.elevation, unit: UnitLength.meters), format: .measurement(width: .abbreviated,
                                                     usage: .asProvided,
                                                     numberFormatStyle: .number))
      Text("Перепад высот")
        .font(.body)
    }
  }

  var speedLabel: some View {
    VStack {
      Text(Measurement(value: viewModel.trainingModel.maxSpeed, unit: UnitSpeed.kilometersPerHour) , format: .measurement(width: .abbreviated,
                                                    usage: .asProvided,
                                                                  numberFormatStyle: .number))
      Text("Максимальная скорость")
        .font(.body)
    }
  }

  var stopButton: some View {
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

  var endButtons: some View {
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
}

// MARK: - PreviewProvider

struct TrainingProgressView_Previews: PreviewProvider {
  static var previews: some View {
    let mainViewModel = MainViewModel(
      trainingModel: TrainingModel(),
      locationService: LocationService(),
      storageService: StorageService()
    )
    mainViewModel.state = .active

    return TrainingProgressView()
      .environment(\.locale, Locale(identifier: "ru_RU"))
      .environmentObject(
        mainViewModel
      )
  }
}

