//
//  UserDataManager.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/04/2021.
//

import SwiftUI
import UserNotifications

struct UserDataManager {
    /// Date formater, which is used to format the date
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// This method sets the zodiac sign from given date
    /// - Parameter date: birthday date - selected by the user
    /// - Returns: string with zodiac sign
    func setZodiac(from date: Date) -> String {
        let components = date.get(.day, .month)
        
        if let day = components.day,
           let month = components.month {
            switch (day, month) {
            case (21...31, 3), (1...20, 4):
                return "🐏 ♈️"
            case (21...30, 4), (1...20, 5):
                return "🐂 ♉️"
            case (21...31, 5), (1...20, 6):
                return "👯‍♀️ ♊️"
            case (21...30, 6), (1...22, 7):
                return "🦀 ♋️"
            case (23...31, 7), (1...23, 8):
                return "🦁 ♌️"
            case (24...31, 8), (1...22, 9):
                return "👰‍♀️ ♍️"
            case (23...30, 9), (1...23, 10):
                return "⚖️ ♎️"
            case (24...31, 10), (1...22, 11):
                return "🦂 ♏️"
            case (23...30, 11), (1...21, 12):
                return "🏹 ♐️"
            case (22...31, 12), (1...19, 1):
                return "🐐 ♑️"
            case (20...31, 1), (1...18, 2):
                return "🌊 ♒️"
            case (19...29, 2), (1...20, 3):
                return "🐟 ♓️"
            default:
                return "⚠️"
            }
        }
        
        return ""
    }
    
    /// This method return Color from the String
    /// - Parameter color: String from picker (which is placed in SettingsView)
    /// - Returns: Accent Color
    func setAccentColor(from color: String) -> Color {
        return Color(color)
    }
    
    /// This method requests permission to notifications
    /// If permission is granted, it schedules notification
    /// Otherwise it prints error
    /// - Parameters:
    ///   - identifier: notification id - name of the person
    ///   - date: birthday date that triggers notification
    ///   - hour: time when the notification will appear - hour
    ///   - minute: time when the notification will appear - minute
    func registerNotification(identifier: String, date: Date, hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                scheduleNotification(identifier: identifier, date: date, hour: hour, minute: minute)
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// This method setups the notification
    /// - Parameters:
    ///   - identifier: notification id - name of the person
    ///   - date: birthday date that triggers notification
    ///   - hour: time when the notification will appear - hour
    ///   - minute: time when the notification will appear - minute
    func scheduleNotification(identifier: String, date: Date, hour: Int, minute: Int) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let birthYear = date.get(.year)
        let center = UNUserNotificationCenter.current()
        
        // Setup notification Content
        let content = UNMutableNotificationContent()
        content.title = "🎂 IT'S BIRTHDAY TIME 🎂"
        content.body = "\(identifier) turns \(currentYear - birthYear) today!"
        content.sound = UNNotificationSound.default
        
        // Setup trigger date
        var triggerDate = DateComponents()
        triggerDate.day = date.get(.day)
        triggerDate.month = date.get(.month)
        triggerDate.hour = hour
        triggerDate.minute = minute
        
        // Setup trigger and request
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Push local notification
        center.add(request)
    }
}
