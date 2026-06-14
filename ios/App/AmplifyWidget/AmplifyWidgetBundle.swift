//
//  AmplifyWidgetBundle.swift
//  AmplifyWidget
//
//  Created by Cam on 6/14/26.
//

import WidgetKit
import SwiftUI

@main
struct AmplifyWidgetBundle: WidgetBundle {
    var body: some Widget {
        AmplifyWidget()
        AmplifyWidgetControl()
        AmplifyWidgetLiveActivity()
    }
}
