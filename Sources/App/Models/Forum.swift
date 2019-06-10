//
// Created by ylw on 2019-06-08.
//
import Vapor
import Fluent
import FluentMySQL
import Foundation

struct Forum: Content, MySQLModel  {
    var id: Int?
    var name: String

    init(id: Int?, name: String) {
        self.id = id
        self.name = name
    }

    init(name: String) {
        self.init(id: nil, name: name)
    }
}
