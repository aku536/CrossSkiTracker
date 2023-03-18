//
//  ContentView.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 17.03.2023.
//

import SwiftUI

struct MainView: View {

  @ObservedObject var viewModel = MainViewModel()

    var body: some View {
        VStack {
          Text(viewModel.date, style: .timer)
          Text(viewModel.distance, format: .measurement(width: .abbreviated, numberFormatStyle: .number))
        }
        .padding()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      MainView().environment(\.locale, Locale(identifier: "ru_RU"))
    }
}
