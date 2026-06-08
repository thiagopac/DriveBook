import SwiftUI

struct ProfileView: View {
    private let accent = Color(red: 0.64, green: 0.58, blue: 1.0)
    private let purple = Color(red: 0.38, green: 0.32, blue: 0.82)
    private let rowBg = Color(white: 0.08)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    profileHeader
                    statsRow
                    settingsSection(title: "My Activity", rows: [
                        SettingsRow(icon: "clock.arrow.circlepath", label: "Viewed History", color: accent),
                        SettingsRow(icon: "arrow.triangle.2.circlepath", label: "Comparisons", color: accent),
                    ])
                    settingsSection(title: "Preferences", rows: [
                        SettingsRow(icon: "bell.fill", label: "Notifications", color: Color(red: 1.0, green: 0.6, blue: 0.2)),
                        SettingsRow(icon: "gauge.high", label: "Units", value: "km/h", color: Color(red: 0.3, green: 0.8, blue: 0.5)),
                        SettingsRow(icon: "moon.fill", label: "Appearance", value: "Dark", color: purple),
                    ])
                    settingsSection(title: "Account", rows: [
                        SettingsRow(icon: "lock.shield.fill", label: "Privacy Policy", color: Color(red: 0.5, green: 0.7, blue: 1.0)),
                        SettingsRow(icon: "questionmark.circle.fill", label: "Help & Support", color: Color(red: 0.5, green: 0.7, blue: 1.0)),
                        SettingsRow(icon: "star.fill", label: "Rate DriveBook", color: Color(red: 1.0, green: 0.85, blue: 0.2)),
                    ])
                    signOutButton
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                }
                .padding(.top, 8)
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [purple, accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 86, height: 86)
                Text("TP")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
            }
            .overlay(alignment: .bottomTrailing) {
                ZStack {
                    Circle().fill(Color.black).frame(width: 26, height: 26)
                    Circle().fill(Color(white: 0.18)).frame(width: 24, height: 24)
                    Image(systemName: "pencil")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            VStack(spacing: 4) {
                Text("Thiago Pires")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Text("@thiagopac")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Button {} label: {
                Text("Edit Profile")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(white: 0.28), lineWidth: 1)
                    )
            }
        }
        .padding(.top, 16)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(value: "4", label: "In Garage")
            Rectangle()
                .fill(Color(white: 0.18))
                .frame(width: 1, height: 34)
            statCell(value: "8", label: "Favorites")
            Rectangle()
                .fill(Color(white: 0.18))
                .frame(width: 1, height: 34)
            statCell(value: "142", label: "Viewed")
        }
        .padding(.vertical, 14)
        .background(rowBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private func settingsSection(title: String, rows: [SettingsRow]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.4))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.label) { idx, row in
                    settingsRowView(row)

                    if idx < rows.count - 1 {
                        Divider()
                            .background(Color.white.opacity(0.07))
                            .padding(.leading, 52)
                    }
                }
            }
            .background(rowBg)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 16)
        }
    }

    private func settingsRowView(_ row: SettingsRow) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(row.color.opacity(0.18))
                        .frame(width: 34, height: 34)
                    Image(systemName: row.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(row.color)
                }

                Text(row.label)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)

                Spacer()

                if let val = row.value {
                    Text(val)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.4))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.25))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }

    private var signOutButton: some View {
        Button {} label: {
            Text("Sign Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(red: 1.0, green: 0.35, blue: 0.35))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(red: 1.0, green: 0.35, blue: 0.35).opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

private struct SettingsRow {
    let icon: String
    let label: String
    var value: String? = nil
    let color: Color
}
