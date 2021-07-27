//
//  BirthdayPicker.swift
//  BirthdayPicker
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 25/07/2021.
//

import SwiftUI

struct BirthdayPicker: View {
    // Properties
    @State private var previousDate: Date = Date()
    @Binding var birthday: Date
    @Binding var isVisible: Bool
    let savingAction: (() -> ())?
    
    var body: some View {
        ZStack {
            // A field outside, which - if has been tapped - hides alert with DatePicker.
            Color.black.opacity(0.00001)
                .onTapGesture {
                    withAnimation { cancelAction() }
                }
            
            // Alert with DatePicker
            VStack {
                Text(LocalizedStrings.chooseBirthday)
                    .padding(.top)
                
                /* MARK: BUG - iOS 15.0 WheelDatePicker style is invisible (but working)
                 On the majority of iPhones with iOS 15.0, the WheelDatePicker is invisible. This DatePicker works on iOS 14.4 (and older); in iOS 15.0
                 Apple introduced slight changes to it. Therefore, in the new version (for this moment - until they share a ready, public version) there will be CompactDatePicker.
                 
                 -- More information and photos in my question: --
                 https://stackoverflow.com/questions/68518594/wheeldatepicker-is-invisible-in-ios-15-0
                */
                if #available(iOS 15.0, *) {
                    DatePicker("",
                               selection: $birthday,
                               in: ...Date(),
                               displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .fixedSize()
                } else {
                    DatePicker("",
                               selection: $birthday,
                               in: ...Date(),
                               displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .fixedSize()
                }
                
                HStack {
                    // Cancel Button
                    Button(action: cancelAction) {
                        Text(LocalizedStrings.cancel)
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    // Save Button
                    Button(LocalizedStrings.save) {
                        if let savingAction = savingAction {
                            savingAction()
                        } else {
                            self.isVisible = false
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .frame(width: UIScreen.main.bounds.width - 10)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 10)
            .onAppear { self.previousDate = birthday }
        }
    }
    
    private func cancelAction() {
        self.birthday = previousDate
        self.isVisible = false
    }
}
