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
                    let vc = getMainViewController()
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let month = calendar.component(.month, from: date)
                    let year = calendar.component(.year, from: date)

                    vc?.setCurrentDay(Int32(day), month: Int32(month), year: Int32(year))

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
