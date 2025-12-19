//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by AJAY KADWAL on 10/12/25.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            Onboarding_Screen()
                .modelContainer(for: [Expense.self])
//                .modelContainer(for: [Note.self])
        }
    }
}
