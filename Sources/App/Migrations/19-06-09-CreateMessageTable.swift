//
// Created by ylw on 2019-06-09.
//

import Foundation
import FluentMySQL

extension Message: Migration {
    
    public static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return Database.create(Message.self, on: conn, closure: { builder in
            try addProperties(to: builder)
        })
    }

    public static func revert(on conn: MySQLConnection) -> Future<Void> {
        return Database.delete(Message.self, on: conn)
    }
}
