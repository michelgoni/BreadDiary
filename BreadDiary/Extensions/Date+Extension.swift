//
//  Date+Extension.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 18/11/24.
//
import Foundation

public extension Date {
    
    static var yearMonthDay: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return calendar.date(from: components) ?? Date()
    }
}
