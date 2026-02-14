//
//  DifficultySelectionView.swift
//  MathFriends
//
//  Difficulty selection screen
//

import SwiftUI

struct DifficultySelectionView: View {
    @ObservedObject var viewModel: PracticeSessionViewModel

    var body: some View {
        ZStack {
            // Background gradient (matching web design)
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.97, blue: 1.0), // blue-50
                    Color(red: 0.93, green: 0.94, blue: 1.0)  // indigo-100
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Title
                Text("MathFriends")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.primary)

                // Difficulty cards
                VStack(spacing: 20) {
                    ForEach(Difficulty.allCases) { difficulty in
                        DifficultyCardView(difficulty: difficulty) {
                            viewModel.selectDifficulty(difficulty)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

#Preview {
    DifficultySelectionView(viewModel: PracticeSessionViewModel())
}
