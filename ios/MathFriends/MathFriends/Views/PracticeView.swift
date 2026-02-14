//
//  PracticeView.swift
//  MathFriends
//
//  Main practice screen with problem display and stats
//

import SwiftUI

struct PracticeView: View {
    @ObservedObject var viewModel: PracticeSessionViewModel
    @State private var userAnswer: String = ""

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.97, blue: 1.0),
                    Color(red: 0.93, green: 0.94, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MathFriends")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)

                            Text("\(viewModel.difficulty.emoji) \(viewModel.difficulty.displayName) - \(viewModel.difficulty.description)")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.showDifficultySelector()
                        }) {
                            Text("Change Level")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        StatCardView(
                            title: "Attempted",
                            value: "\(viewModel.stats.totalAttempted)",
                            color: .primary
                        )

                        StatCardView(
                            title: "Correct",
                            value: "\(viewModel.stats.correct)",
                            color: .green
                        )

                        StatCardView(
                            title: "Current Streak",
                            value: "\(viewModel.stats.currentStreak)",
                            color: .blue
                        )

                        StatCardView(
                            title: "Best Streak",
                            value: "\(viewModel.stats.bestStreak)",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)

                    // Feedback Banner
                    if let feedback = viewModel.feedback {
                        FeedbackBannerView(feedback: feedback) {
                            viewModel.clearFeedback()
                        }
                        .padding(.horizontal)
                    }

                    // Problem Display
                    if let problem = viewModel.currentProblem {
                        ProblemDisplayView(
                            problem: problem,
                            userAnswer: $userAnswer,
                            isLoading: viewModel.isLoading,
                            onSubmit: {
                                handleSubmit()
                            }
                        )
                        .padding(.horizontal)
                        .onChange(of: problem.id) { _ in
                            userAnswer = ""
                        }
                    } else if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.vertical, 100)
                    }

                    // Accuracy
                    if viewModel.stats.totalAttempted > 0 {
                        Text("Accuracy: \(Int(viewModel.stats.accuracy * 100))%")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            if viewModel.currentProblem == nil && !viewModel.isLoading {
                viewModel.loadProblem()
            }
        }
    }

    private func handleSubmit() {
        guard let answer = Double(userAnswer) else { return }
        viewModel.submitAnswer(answer)
    }
}

#Preview {
    let viewModel = PracticeSessionViewModel()
    viewModel.difficulty = .easy
    viewModel.showingDifficultySelector = false
    return PracticeView(viewModel: viewModel)
}
