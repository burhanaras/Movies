//
//  RefreshableView.swift
//  Pixel_Perfect_SwiftUI
//
//  Created by Burhan Aras on 26.12.2021.
//

// From: https://github.com/gualtierofrigerio/FeedReader/blob/master/FeedReader/Views/RefreshableView.swift


import SwiftUI

struct RefreshableView<Content:View>: View {
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.refreshAction = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                        geometry[$0].y
                    }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { offset in
                if offset > threshold {
                    refreshAction()
                }
            }
        }
    }
    
    
    private var content: () -> Content
    private var refreshAction: () -> Void
    private let threshold:CGFloat = 50.0
}

fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RefreshableView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableView(action: {}, content:{Text("test")})
    }
}
