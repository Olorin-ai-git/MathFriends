//
//  FeedbackBannerView.swift
//  MathFriends
//
//  Feedback banner showing correct/incorrect/try-again status
//

import SwiftUI

struct FeedbackBannerView: View {
    let feedback: Feedback
    let onTryAgain: () -> Void

    private var backgroundColor: Color {
        if feedback.isCorrect {
            return .green
        } else if feedback.outOfAttempts {
            return .red
        } else {
            return .orange
        }
    }

    private var icon: String {
        if feedback.isCorrect {
            return "\u{2705}"
        } else if feedback.outOfAttempts {
            return "\u{274C}"
        } else {
            return "\u{1F914}"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 28))

            Text(feedback.message)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if feedback.isCorrect {
                Text("Next...")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            } else if feedback.outOfAttempts {
                Text("Moving on...")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            } else {
                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

#Preview {
    VStack(spacing: 20) {
        FeedbackBannerView(
            feedback: Feedback(isCorrect: true, message: "Great job! That's correct!"),
            onTryAgain: {}
        )

        FeedbackBannerView(
            feedback: Feedback(isCorrect: false, message: "Not quite! 3 tries remaining"),
            onTryAgain: {}
        )

        FeedbackBannerView(
            feedback: Feedback(isCorrect: false, message: "The correct answer is 42", outOfAttempts: true),
            onTryAgain: {}
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
