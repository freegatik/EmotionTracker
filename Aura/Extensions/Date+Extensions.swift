//
//  Date+Extensions.swift
//  Aura
//
//  Created by Anton Solovev on 05.04.2025.
//

import Foundation

extension Date {
    func toString(format: String = "HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func formattedRelativeTime() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if calendar.isDateInToday(self) {
            return "\(LocalizedKey.Log.todayString), \(formatter.string(from: self))"
        } else if calendar.isDateInYesterday(self) {
            return "\(LocalizedKey.Log.yesterdayString), \(formatter.string(from: self))"
        } else if let daysAgo = calendar.dateComponents([.day], from: self, to: now).day, daysAgo > 0 {
            let dayWord = pluralize(count: daysAgo, one: "день", few: "дня", many: "дней")
            return "\(daysAgo) \(dayWord) назад, \(formatter.string(from: self))"
        }
        
        return formatter.string(from: self)
    }
}
