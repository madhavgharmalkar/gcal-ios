//
//  GCalDataBinder.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/17/22.
//

import Foundation

class GCalDataBinder: ObservableObject {
    @Published var date: Date

    init() {
        self.date = Date()

    }
}
