import WidgetKit
import SwiftUI

// ─── App Group ID ─────────────────────────────────────────────────────────────
// Add "group.com.cam.amplify" as an App Group in Xcode Signing & Capabilities
// for BOTH your main App target AND the Widget Extension target.
let APP_GROUP = "group.com.cam.amplify"

// ─── Shared Data Model ────────────────────────────────────────────────────────

struct AmplifyData {
    var streakDays: Int
    var currentGoal: String
    var dailyMessage: String
    var inRoom: Bool
    var roomName: String
    var roomTimer: String

    static func load() -> AmplifyData {
        let defaults = UserDefaults(suiteName: APP_GROUP) ?? UserDefaults.standard
        return AmplifyData(
            streakDays:   defaults.integer(forKey: "amp_streak_days"),
            currentGoal:  defaults.string(forKey: "amp_widget_goal")    ?? "Set your goal for today",
            dailyMessage: defaults.string(forKey: "amp_widget_message") ?? "Make some noise for yourself.",
            inRoom:       defaults.bool(forKey: "amp_in_room"),
            roomName:     defaults.string(forKey: "amp_room_name")      ?? "Live Room",
            roomTimer:    defaults.string(forKey: "amp_room_timer")     ?? "00:00"
        )
    }
}

// ─── Timeline Entry ───────────────────────────────────────────────────────────

struct AmplifyEntry: TimelineEntry {
    let date: Date
    let data: AmplifyData
}

// ─── Timeline Provider ────────────────────────────────────────────────────────

struct AmplifyProvider: TimelineProvider {
    func placeholder(in context: Context) -> AmplifyEntry {
        AmplifyEntry(date: Date(), data: AmplifyData(
            streakDays: 7,
            currentGoal: "Finish the project",
            dailyMessage: "Make some noise for yourself.",
            inRoom: false, roomName: "", roomTimer: ""
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (AmplifyEntry) -> Void) {
        completion(AmplifyEntry(date: Date(), data: AmplifyData.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AmplifyEntry>) -> Void) {
        let entry = AmplifyEntry(date: Date(), data: AmplifyData.load())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

// ─── Colors ───────────────────────────────────────────────────────────────────

extension Color {
    static let ampBackground = Color(red: 0.059, green: 0.055, blue: 0.047)
    static let ampGold       = Color(red: 0.788, green: 0.663, blue: 0.431)
    static let ampText       = Color(red: 0.910, green: 0.878, blue: 0.831)
    static let ampMuted      = Color(red: 0.910, green: 0.878, blue: 0.831).opacity(0.4)
    static let ampGreen      = Color(red: 0.114, green: 0.620, blue: 0.455)
}

// ─── Small Widget ─────────────────────────────────────────────────────────────

struct SmallWidgetView: View {
    let data: AmplifyData

    var body: some View {
        ZStack {
            Color.ampBackground
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("AMPLIFY")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1.5)
                        .foregroundColor(.ampMuted)
                    Spacer()
                    Text("🔥")
                        .font(.system(size: 12))
                }
                Spacer()
                if data.inRoom {
                    Text(data.roomName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.ampGold)
                        .lineLimit(1)
                    Text(data.roomTimer)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.ampText)
                } else {
                    Text("\(data.streakDays)")
                        .font(.custom("Georgia", size: 42))
                        .fontWeight(.bold)
                        .foregroundColor(.ampGold)
                    Text("day streak")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.ampMuted)
                }
            }
            .padding(14)
        }
    }
}

// ─── Medium Widget ────────────────────────────────────────────────────────────

struct MediumWidgetView: View {
    let data: AmplifyData

    var body: some View {
        ZStack {
            Color.ampBackground
            HStack(spacing: 0) {
                // Left panel — streak or timer
                VStack(alignment: .leading, spacing: 4) {
                    Text("AMPLIFY")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1.5)
                        .foregroundColor(.ampMuted)
                    Spacer()
                    if data.inRoom {
                        Text(data.roomTimer)
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundColor(.ampGold)
                        Text(data.roomName)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.ampMuted)
                            .lineLimit(1)
                    } else {
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text("\(data.streakDays)")
                                .font(.custom("Georgia", size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(.ampGold)
                            Text("🔥")
                                .font(.system(size: 20))
                        }
                        Text("\(data.streakDays) day streak")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.ampMuted)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 14)
                .padding(.vertical, 14)

                // Divider
                Rectangle()
                    .fill(Color.ampGold.opacity(0.15))
                    .frame(width: 1)
                    .padding(.vertical, 16)

                // Right panel — message or goal
                VStack(alignment: .leading, spacing: 6) {
                    if data.inRoom {
                        Text("IN SESSION")
                            .font(.system(size: 8, weight: .bold))
                            .tracking(1.5)
                            .foregroundColor(.ampGreen.opacity(0.8))
                        Text(data.currentGoal)
                            .font(.custom("Georgia", size: 13))
                            .foregroundColor(.ampText)
                            .lineLimit(4)
                    } else {
                        Text("TODAY")
                            .font(.system(size: 8, weight: .bold))
                            .tracking(1.5)
                            .foregroundColor(.ampMuted)
                        Text(data.dailyMessage)
                            .font(.custom("Georgia", size: 13))
                            .foregroundColor(.ampText)
                            .lineLimit(4)
                        Spacer()
                        if !data.currentGoal.isEmpty && data.currentGoal != "Set your goal for today" {
                            Text(data.currentGoal)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.ampGold)
                                .lineLimit(2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
            }
        }
    }
}

// ─── Lock Screen Widget ───────────────────────────────────────────────────────

struct LockScreenWidgetView: View {
    let data: AmplifyData

    var body: some View {
        if data.inRoom {
            HStack(spacing: 4) {
                Text("🔥")
                Text(data.roomTimer)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                Text("·")
                    .foregroundColor(.secondary)
                Text(data.roomName)
                    .font(.system(size: 11))
                    .lineLimit(1)
            }
        } else {
            HStack(spacing: 4) {
                Text("🔥")
                Text("\(data.streakDays) days")
                    .font(.system(size: 13, weight: .bold))
                Text("·")
                    .foregroundColor(.secondary)
                Text(data.dailyMessage)
                    .font(.system(size: 11))
                    .lineLimit(1)
            }
        }
    }
}

// ─── Entry View Router ────────────────────────────────────────────────────────

struct AmplifyWidgetEntryView: View {
    var entry: AmplifyEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(data: entry.data)
        case .systemMedium:
            MediumWidgetView(data: entry.data)
        case .accessoryRectangular:
            LockScreenWidgetView(data: entry.data)
        default:
            SmallWidgetView(data: entry.data)
        }
    }
}

// ─── Widget Bundle ────────────────────────────────────────────────────────────

@main
struct AmplifyWidget: Widget {
    let kind: String = "AmplifyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AmplifyProvider()) { entry in
            AmplifyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Amplify")
        .description("Your streak, goal, and daily message.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

