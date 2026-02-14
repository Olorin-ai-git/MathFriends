//
//  ProblemDisplayView.swift
//  MathFriends
//
//  Problem display and answer input component
//

import SwiftUI

struct ProblemDisplayView: View {
    let problem: AnyProblem
    @Binding var userAnswer: String
    let isLoading: Bool
    let onSubmit: () -> Void

    @State var userAnswerY: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            // Problem text
            VStack(spacing: 12) {
                Text("Problem:")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                if let systemProblem = problem.asSystemEquationProblem {
                    VStack(spacing: 8) {
                        Text(systemProblem.equation1)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                        Text(systemProblem.equation2)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                } else {
                    Text(problem.displayString())
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }

            // Answer input
            VStack(spacing: 12) {
                if problem.isSystemEquation {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("x =")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            TextField("Value of x", text: $userAnswer)
                                .keyboardType(.numbersAndPunctuation)
                                .font(.system(size: 18))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: isInputFocused ? 2 : 0)
                                )
                                .focused($isInputFocused)
                                .disabled(isLoading)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("y =")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            TextField("Value of y", text: $userAnswerY)
                                .keyboardType(.numbersAndPunctuation)
                                .font(.system(size: 18))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .disabled(isLoading)
                        }
                    }
                } else {
                    TextField("Enter your answer", text: $userAnswer)
                        .keyboardType(.numbersAndPunctuation)
                        .font(.system(size: 18))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: isInputFocused ? 2 : 0)
                        )
                        .focused($isInputFocused)
                        .disabled(isLoading)
                }

                Button(action: onSubmit) {
                    Text(isLoading ? "Checking..." : "Submit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitDisabled ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(isSubmitDisabled)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            isInputFocused = true
        }
    }

    private var isSubmitDisabled: Bool {
        if isLoading { return true }
        if userAnswer.isEmpty { return true }
        if problem.isSystemEquation && userAnswerY.isEmpty { return true }
        return false
    }
}

#Preview {
    VStack {
        ProblemDisplayView(
            problem: AnyProblem(BasicProblem(
                id: "1",
                num1: 5,
                num2: 3,
                operation: .addition,
                answer: 8,
                difficulty: .easy
            )),
            userAnswer: .constant(""),
            isLoading: false,
            onSubmit: {}
        )

        ProblemDisplayView(
            problem: AnyProblem(EquationProblem(
                id: "2",
                equation: "3x + 5 = 20",
                answer: 5,
                difficulty: .hard
            )),
            userAnswer: .constant(""),
            isLoading: false,
            onSubmit: {}
        )

        ProblemDisplayView(
            problem: AnyProblem(SystemEquationProblem(
                id: "3",
                equation1: "2x + 3y = 13",
                equation2: "x - y = 1",
                answerX: 4,
                answerY: 3,
                difficulty: .extreme
            )),
            userAnswer: .constant(""),
            isLoading: false,
            onSubmit: {}
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
