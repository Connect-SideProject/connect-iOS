//
//  Date+Extension.swift
//  COExtensions
//
//  Created by sean on 2022/11/21.
//

import Foundation

public extension Date {
  func afterDate(year: Int = 0, month: Int = 0, day: Int = 0) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    return Calendar.current.date(byAdding: dateComponents, to: self)!
  }
  
  func toFormattedString(
    dateFormat: String = "yyyy-MM-dd",
    locale: Locale = .init(identifier: "ko_kr"),
    timeZone: TimeZone? = .init(abbreviation: "KST")
  ) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = locale
    formatter.timeZone = timeZone
    return formatter.string(from: self)
  }
  
  func toDate(
    dateFormat: String = "yyyy-MM-dd",
    locale: Locale = .init(identifier: "ko_kr"),
    timeZone: TimeZone = .init(abbreviation: "KST")!
  ) -> Date {
    
    let calendar = Calendar.current
    var components = calendar.dateComponents(in: timeZone, from: self)
    components.timeZone = timeZone
    return calendar.date(from: components)!
  }
  
  func toDdayFormattedStr() -> String? {
    guard let daysLeft = Calendar.current.dateComponents([.day], from: self, to: Date()).day else { return nil }
    return daysLeft >= 0 ? "D+\(daysLeft)" : "D\(daysLeft)"
  }
}
