//
// Created by ylw on 2019-06-08.
//

import Fluent
import FluentMySQL

extension Forum: Migration {

    typealias Database = MySQLDatabase

    public static func prepare(on conn: Database.Connection) -> Future<Void> {
        return Database.create(Forum.self, on: conn) {
            builder in
            try addProperties(to: builder)
        }
    }

    public static func revert(on conn: Database.Connection) -> Future<Void> {
        return Database.delete(Forum.self, on: conn)
    }
}