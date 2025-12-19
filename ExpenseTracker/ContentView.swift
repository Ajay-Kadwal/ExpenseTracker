//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by AJAY KADWAL on 10/12/25.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
}


struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [Note] // load all the notes automatically
    @State var textFiledText: String = ""
    @State var showError: Bool = false
    @State var errorTitle: String = ""
    
    var body: some View {
        VStack {
           TextField("ADD TEXT", text: $textFiledText)
                .padding()
                .background(.gray.opacity(0.3))
                .cornerRadius(19)
                .padding()
            
            Button("ADD NOTE") {
                let note = Note(text: textFiledText)
                if !textFiledText.isEmpty {
                    context.insert(note)
                    textFiledText = ""
                } else {
                    errorTitle = "Please Enter proper text!!‼️‼️"
                    showError = true
                }
            }
            .alert(errorTitle, isPresented: $showError, actions: {})
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(19)
            .padding()
        }
        
        List {
            ForEach(notes) { note in
                Text(note.text)
            }
            .onDelete { IndexSet in
                IndexSet.forEach { i in
                    context.delete(notes[i])
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
