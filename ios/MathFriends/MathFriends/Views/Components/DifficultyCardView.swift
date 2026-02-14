//
//  DifficultyCardView.swift
//  MathFriends
//
//  Individual difficulty selection card
//

import SwiftUI

struct DifficultyCardView: View {
    let difficulty: Difficulty
    let onSelect: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 16) {
                Text(difficulty.emoji)
                    .font(.system(size: 60))

                Text(difficulty.displayName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)

                Text(difficulty.description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(isPressed ? 0.3 : 0.15), radius: isPressed ? 12 : 8, x: 0, y: isPressed ? 6 : 4)
            .scaleEffect(isPressed ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

#Preview {
    VStack(spacing: 24) {
        DifficultyCardView(difficulty: .superEasy) {}
        DifficultyCardView(difficulty: .easy) {}
        DifficultyCardView(difficulty: .medium) {}
        DifficultyCardView(difficulty: .hard) {}
        DifficultyCardView(difficulty: .extreme) {}
    }
    .padding()
    .background(
        LinearGradient(
            colors: [Color(red: 0.94, green: 0.97, blue: 1.0), Color(red: 0.93, green: 0.94, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
