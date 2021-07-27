//
//  UserDataManager.swift
//  Zodiacally
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/04/2021.
//

import SwiftUI
import UserNotifications

struct UserDataManager {
    static let shared = UserDataManager()
    
    /// Date formater, which is used to format the date
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// This method sets the zodiac sign from given date
    /// - Parameter date: birthday date - selected by the user
    /// - Returns: string tuple with zodiac signs as string and symbols
    func setZodiac(from date: Date) -> (string: String, symbol: String) {
        let components = date.get(.day, .month)
        
        if let day = components.day,
           let month = components.month {
            switch (day, month) {
            case (21...31, 3), (1...20, 4):
                return (string: LocalizedStrings.aries, symbol: "🐏 ♈️")
            case (21...30, 4), (1...20, 5):
                return (string: LocalizedStrings.taurus, symbol: "🐂 ♉️")
            case (21...31, 5), (1...20, 6):
                return (string: LocalizedStrings.gemini, symbol: "👯‍♀️ ♊️")
            case (21...30, 6), (1...22, 7):
                return (string: LocalizedStrings.cancer, symbol: "🦀 ♋️")
            case (23...31, 7), (1...23, 8):
                return (string: LocalizedStrings.leo, symbol: "🦁 ♌️")
            case (24...31, 8), (1...22, 9):
                return (string: LocalizedStrings.virgo, symbol: "👰‍♀️ ♍️")
            case (23...30, 9), (1...23, 10):
                return (string: LocalizedStrings.libra, symbol: "⚖️ ♎️")
            case (24...31, 10), (1...22, 11):
                return (string: LocalizedStrings.scorpio, symbol: "🦂 ♏️")
            case (23...30, 11), (1...21, 12):
                return (string: LocalizedStrings.sagittarius, symbol: "🏹 ♐️")
            case (22...31, 12), (1...19, 1):
                return (string: LocalizedStrings.capricorn, symbol: "🐐 ♑️")
            case (20...31, 1), (1...18, 2):
                return (string: LocalizedStrings.aquarius, symbol: "🌊 ♒️")
            case (19...29, 2), (1...20, 3):
                return (string: LocalizedStrings.pisces, symbol: "🐟 ♓️")
            default:
                return (string: "ERROR", symbol: "⚠️")
            }
        }
        
        return (string: "", symbol: "")
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
    func registerNotification(identifier: String, name: String, date: Date, hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                scheduleNotification(identifier: identifier, name: name, date: date, hour: hour, minute: minute)
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
    func scheduleNotification(identifier: String, name: String, date: Date, hour: Int, minute: Int) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let birthYear = date.get(.year)
        let center = UNUserNotificationCenter.current()
        
        // Setup notification Content
        let content = UNMutableNotificationContent()
        content.title = LocalizedStrings.notificationTitle
        content.body = "\(name) \(LocalizedStrings.turns) \(currentYear - birthYear)\(LocalizedStrings.today)!"
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
    
    func translateAccentColor(selected color: String) -> String {
        switch color {
            case "Red":     return LocalizedStrings.red
            case "Green":   return LocalizedStrings.green
            case "Blue":    return LocalizedStrings.blue
            case "Pink":    return LocalizedStrings.pink
            case "Purple":  return LocalizedStrings.purple
            case "Yellow":  return LocalizedStrings.yellow
            case "Cyan":    return LocalizedStrings.cyan
            case "Mint":    return LocalizedStrings.mint
            case "Gray":    return LocalizedStrings.gray
            case "Orange":  return LocalizedStrings.orange
            default:        return LocalizedStrings.purple
        }
    }
}
