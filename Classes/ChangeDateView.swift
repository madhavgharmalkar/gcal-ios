//
//  ChangeDateView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/20/22.
//

import SwiftUI

struct ChangeDateView: View {
    @State private var date = Date()

    @Binding var isPresented: Bool
    @EnvironmentObject private var applicationState: GCApplicationState

    var body: some View {
        VStack(spacing: 10) {
            DatePicker(selection: $date, displayedComponents: .date) {
                Text("Select a date")
            }
            .datePickerStyle(.graphical)
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.bordered)

                Button {
                    applicationState.date = date
                    isPresented.toggle()
                } label: {
                    Text("Set")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

struct ChangeDateView_Previews: PreviewProvider {
    static var previews: some View {
        Text("hare krishna!")
            .sheet(isPresented: .constant(true)) {
                ChangeDateView(isPresented: .constant(true))
                    .presentationDetents([.medium])
            }
    }
}
