//
//  ContentView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import SwiftUI

struct MainView: View {

  @ObservedObject var viewModel = MainViewModel()

  // MARK: - Body

  var body: some View {
    if viewModel.inProgress {
      NavigationView {
        VStack {
          HStack {
            Text(viewModel.date, style: .timer)
              .border(.black)
              .padding(4)
            VStack {
              Text(viewModel.distance, format: .measurement(width: .abbreviated, numberFormatStyle: .number))
                .border(.black)
                .padding(4)
                .onTapGesture {
                  viewModel.didTapLocation()
                }
              Text(viewModel.elevation, format: .measurement(width: .abbreviated, numberFormatStyle: .number))
                .border(.black)
                .padding(4)
            }
          }
          .font(.largeTitle)
          NavigationLink(destination: {
            viewModel.didTapMapOpen()
          }) {
            Text("Открыть карту")
          }
          Button("Стоп") {
            viewModel.inProgress = false
          }

          .background(.red)
          .foregroundColor(.white)
         }
        .padding()
      }
    } else {
      startButton
    }
  }

  // MARK: - Приватные свойства

  private var startButton: some View {
    Button(action: {
      viewModel.inProgress = true
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
    MainView().environment(\.locale, Locale(identifier: "ru_RU"))
  }
}
