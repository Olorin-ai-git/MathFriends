//
//  StatCardView.swift
//  MathFriends
//
//  Individual statistics card component
//

import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCardView(title: "Attempted", value: "42", color: .primary)
        StatCardView(title: "Correct", value: "38", color: .green)
        StatCardView(title: "Streak", value: "5", color: .blue)
        StatCardView(title: "Best", value: "12", color: .purple)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
