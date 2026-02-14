//
//  MathFriendsApp.swift
//  MathFriends
//
//  Native iOS Math Friends App - Swift/SwiftUI
//  Direct port from React web application
//

import SwiftUI

@main
struct MathFriendsApp: App {
    @StateObject private var viewModel = PracticeSessionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: PracticeSessionViewModel

    var body: some View {
        if viewModel.showingDifficultySelector {
            DifficultySelectionView(viewModel: viewModel)
        } else {
            PracticeView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView(viewModel: PracticeSessionViewModel())
}
