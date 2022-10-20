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
            Text("Select a date")
                .font(.title)
            DatePicker(selection: $date, displayedComponents: .date) {
                Text("Select a date")
            }
            .datePickerStyle(.graphical)
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented.toggle()
                }
                .buttonStyle(.bordered)
                Button("Okay") {
                    let vc = getMainViewController()
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let month = calendar.component(.month, from: date)
                    let year = calendar.component(.year, from: date)

                    vc?.setCurrentDay(Int32(day), month: Int32(month), year: Int32(year))

                    isPresented.toggle()
                }.buttonStyle(.borderedProminent)
            }
        }
        .background(.white)
        .padding()
    }
}

struct ChangeDateView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeDateView(isPresented: .constant(true))
    }
}
