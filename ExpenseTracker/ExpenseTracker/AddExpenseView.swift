//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by AJAY KADWAL on 12/12/25.
//

import SwiftUI
import SwiftData
import Charts

@Model
class Expense {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var category: String
    
    // oprational initializer
    init(
        id: UUID = .init(),
        title: String,
        amount: Double,
        date: Date = .now,
        category: String)
    {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        
        // This Struture is ensures clean data handling
        // predictable state transitions across the applications.
    }
}

//extension Array where Element == Expense {
//    func monthlySummary() -> [(month: String, total: Double)] {
//        let grouped = Dictionary(grouping: self) { expense in
//            expense.date.formatted(.dateTime.year().month())
//        }
//        
//        return grouped.map { (key, value) in
//            let total = value.reduce(0) { $0 + $1.amount }
//            return (month: key, total: total)
//        }
//        .sorted { $0.month < $1.month }
//    }
//}

struct AddExpenseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var expense: [Expense]
    @State var title: String = ""
    @State var amount: String = ""
    @State var date: Date = .now
    @State var category: String = "Food"
    @State var showExpense: Bool = false
    let categories = ["Food", "Travel", "Bills", "Shopping", "Others"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    // Title Field
                    TextField("Enter Title hear...", text: $title)
                    
                    // Amount Field
                    TextField("Enter Amount hear...", text: $amount)
                        .keyboardType(.decimalPad)
                        .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        // it close the keyboard
                                        // use when we need to close the keyboard before
                                        // showing and randring the .sheet
                                        // dismissing the keyborad after entering the data
                                        UIApplication.shared.sendAction(
                                            #selector(UIResponder.resignFirstResponder),
                                            to: nil,
                                            from: nil,
                                            for: nil
                                        )
                                    }
                                }
                            }
                    
                    // Category Picker
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { item  in
                            Text(item)
                        }
                    }
                    
                    // Date Picker
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
            }
            
            Button("Show Expense") {
                showExpense = true
            }
            .font(.title2)
            .sheet(isPresented: $showExpense) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Monthly Spending Chart
                    Text("Monthly Spending Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(expense, id: \.self) { item in
                            BarMark(
                                x: .value("Month", item.date),
                                y: .value("Total", item.amount)
                            )
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.bottom, 8)
                    
                    // MARK: - Expense List
                    List {
                        ForEach(expense, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(item.title)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text("₹\(item.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                                Text(item.category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(item.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.bottom, 60)
            .navigationTitle("ADD Expense")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("SAVE") {
                        save()
                    }
                }
            }
        }
    }
    
    
    // save to existing SWIFTDATA Model
    func save() {
        guard let amountDouble = Double(amount) else { return }
        
        let expense = Expense(
            title: title,
            amount: amountDouble,
            date: date,
            category: category
        )
        context.insert(expense)
        
        // Commit changes and close sheet
        dismiss()
    }
    
    func delete(indexset: IndexSet) {
        indexset.forEach { i in
            context.delete(expense[i])
            do {
                try context.save()
            } catch {
                print("Error Accruing during saving Data try again!!")
            }
        }
    }
}

#Preview {
    AddExpenseView()
}
