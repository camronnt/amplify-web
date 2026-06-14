//
//  AmplifyWidgetLiveActivity.swift
//  AmplifyWidget
//
//  Created by Cam on 6/14/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AmplifyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct AmplifyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AmplifyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension AmplifyWidgetAttributes {
    fileprivate static var preview: AmplifyWidgetAttributes {
        AmplifyWidgetAttributes(name: "World")
    }
}

extension AmplifyWidgetAttributes.ContentState {
    fileprivate static var smiley: AmplifyWidgetAttributes.ContentState {
        AmplifyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: AmplifyWidgetAttributes.ContentState {
         AmplifyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: AmplifyWidgetAttributes.preview) {
   AmplifyWidgetLiveActivity()
} contentStates: {
    AmplifyWidgetAttributes.ContentState.smiley
    AmplifyWidgetAttributes.ContentState.starEyes
}
