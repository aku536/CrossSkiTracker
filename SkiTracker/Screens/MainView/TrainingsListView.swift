//
//  TrainingsListView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 01.06.2023.
//

import SwiftUI

struct TrainingsListView: View {
  
  @EnvironmentObject var viewModel: MainViewModel
  
  // MARK: - Body

  var body: some View {
    VStack {
      if viewModel.savedTrainings.isEmpty {
        emptyView
      } else {
        trainingsListView
      }
    }
  }
}

// MARK: - Приватные свойства

private extension TrainingsListView {
  var trainingsListView: some View {
    List(viewModel.savedTrainings.sorted(by: { $0.date > $1.date })) { training in
      HStack {

        let month = training.date
          .formatted(
            Date.FormatStyle(locale:
                .init(identifier: "ru_RU")
            )
            .day()
            .month(.wide)
          )
          .filter { $0.isLetter }

        VStack {
          Text(training.date, format: Date.FormatStyle().day())
            .lineLimit(1)
          Text(month)
            .lineLimit(1)
        }

        VStack {

          HStack {
            Text("Тренировка")
            Spacer()
          }

          HStack {
            Text("\(training.trainingTime.timeFormat)")

            Divider().frame(height: 20)

            Text(
              Measurement(
                value: training.distance,
                unit: UnitLength.kilometers
              ),
              format: .measurement(width: .abbreviated, usage: .asProvided)
            )

            Spacer()

          }
        }
        .lineLimit(1)

      }
      .deleteDisabled(false)
      .swipeActions(edge: .trailing) {
        Button(role: .destructive) {
          viewModel.deleteTraining(with: training.id)
        } label: {
          Label("Delete", systemImage: "trash")
        }

      }
    }

  }

  var emptyView: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()

        ZStack {
          RoundedRectangle(
            cornerSize: CGSize(width: 20, height: 20),
            style: .continuous
          )
          .foregroundStyle(.brown)
          .padding(.horizontal)
          .frame(height: geometry.size.height / 3)

          Text("Вы пока не провели ни одной тренировки")
            .foregroundStyle(.secondary)
            .font(.title)
            .multilineTextAlignment(.center)
            .shadow(radius: 20)
        }

        Spacer()
      }
    }
  }
}

// MARK: - PreviewProvider

struct TrainingsListView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = MainViewModel(
      trainingModel: TrainingModel(),
      locationService: LocationService(),
      storageService: StorageService()
    )
    viewModel.savedTrainings = [
      TrainingModel(trainingTime: 59, distance: 2000000, elevation: 30, maxSpeed: 30, date: Date(timeIntervalSince1970: 60*60*24*31*1)),
      TrainingModel(trainingTime: 125, distance: 2000000, elevation: 30, maxSpeed: 30, date: Date(timeIntervalSinceReferenceDate: 0)),
      TrainingModel(trainingTime: 3723, distance: 2000000, elevation: 30, maxSpeed: 30, date: Date()),
      TrainingModel(trainingTime: 60, distance: 2000000, elevation: 30, maxSpeed: 30, date: Date()),
      TrainingModel(trainingTime: 36000, distance: 2000000, elevation: 30, maxSpeed: 30, date: Date()),
    ]

    return TrainingsListView()
      .environment(\.locale, Locale(identifier: "ru_RU"))
      .environmentObject(viewModel)
  }
}
