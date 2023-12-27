//
//  MyDayWidget.swift
//  MyDayWidget
//
//  Created by 김채연 on 12/8/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MyDayEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return MyDayEntry(date: Date(), title1: "나의 일정1", strDay1: "D-1", strDate1: formatter.string(from: Date())
                          , title2: "나의 기념일2", strDay2: "D+1", strDate2: formatter.string(from: Date()))
    }

    func getSnapshot(in context: Context, completion: @escaping (MyDayEntry) -> ()) {
        let entry: MyDayEntry
        if context.isPreview{
          entry = placeholder(in: context)
        }
        else{
            let userDefaults = UserDefaults(suiteName: "group.mydayWidget")
            let title1 = userDefaults?.string(forKey: "title1") ?? "-"
            let day1 = userDefaults?.string(forKey: "day1") ?? ""
            let date1 = userDefaults?.string(forKey: "date1") ?? ""
            
            let title2 = userDefaults?.string(forKey: "title2") ?? "-"
            let day2 = userDefaults?.string(forKey: "day2") ?? ""
            let date2 = userDefaults?.string(forKey: "date2") ?? ""
            
            entry = MyDayEntry(date: Date(), title1: title1, strDay1: day1, strDate1: date1
                               , title2: title2, strDay2: day2, strDate2: date2)
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
          let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
    }
}

struct MyDayEntry: TimelineEntry {
    let date: Date
    let title1: String
    let strDay1: String //d-0
    let strDate1: String //yyyy.MM.dd
    
    let title2: String
    let strDay2: String //d-0
    let strDate2: String //yyyy.MM.dd
}

struct MyDayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(entry.title1).font(.system(size: 20, weight: .bold))
                    Text(entry.strDate1).font(.system(size: 15)).foregroundStyle(.gray)
                }
                Spacer()
                Text(entry.strDay1).font(.system(size: 25, weight: .bold))
            }
            Divider()
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(entry.title2).font(.system(size: 20, weight: .bold))
                    Text(entry.strDate2).font(.system(size: 15)).foregroundStyle(.gray)
                }
                Spacer()
                Text(entry.strDay2).font(.system(size: 25, weight: .bold))
            }
        }.containerBackground(for: .widget) {
            Color.white
        } 
    }
}

struct MyDayWidget: Widget {
    let kind: String = "MyDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MyDay")
        .description("주요 일정 2개까지 표시 가능합니다.")
        .supportedFamilies([.systemMedium])
    }
}
