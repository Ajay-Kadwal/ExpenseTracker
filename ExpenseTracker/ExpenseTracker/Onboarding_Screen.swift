//
//  Onboarding_Screen.swift
//  ExpenseTracker
//
//  Created by AJAY KADWAL on 12/12/25.
//

import SwiftUI

struct Onboarding_Screen: View {
    @State var showMainApp: Bool = false
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // App Icon / Illustration
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                }
                .padding(.top, 40)
                
                // Main Heading
                Text("Expense Tracker")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)
                
                // Sub-Heading
                Text("Monitor your spending, visualize your habits,\nand stay financially in control.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Feature Highlights
                VStack(alignment: .leading, spacing: 18) {
                    IntroItem(icon: "chart.bar.xaxis", title: "Visualize Monthly Spending")
                    IntroItem(icon: "banknote.fill", title: "Track Every Transaction")
                    IntroItem(icon: "clock.fill", title: "Faster Input Workflow")
                    IntroItem(icon: "shield.checkerboard", title: "Secure Local Data")
                }
                .padding(.horizontal, 40)
                .padding(.top, 10)
                
                Spacer()
                
                // CTA Button
                Button {
                    showMainApp = true
                } label: {
                    Text("Get Started")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 10)
                }
                .sheet(isPresented: $showMainApp, content: {
                    AddExpenseView()
                })
                .padding(.horizontal, 50)
                .padding(.bottom, 30)
            }
        }
    }
}

// Reusable Bullet Item Row
struct IntroItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .font(.title3)
                .frame(width: 30)
            
            Text(title)
                .foregroundStyle(.white.opacity(0.95))
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

#Preview {
    Onboarding_Screen()
}
