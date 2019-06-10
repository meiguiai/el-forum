//
// Created by ylw on 2019-06-09.
//

import Vapor
import Fluent
import FluentMySQL
import Foundation

struct Message: Content, MySQLModel {
    var id: Int?
    var forumId: Int
    var title: String
    var content: String
    var originId: Int
    var author: String
    var createdAt: Date
}
