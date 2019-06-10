import Vapor
import Fluent
import Crypto
import FluentMySQL

struct UserContext: Codable, Content {
    var username: String?
    var forums: [Forum]
}

func getUsername(_ of: Request) -> String? {
    return "Enter-Y"
}

struct MessageContext: Codable, Content {
    var username: String?
    var forum: Forum
    var messages: [Message]
}

struct ReplyContext: Codable, Content {
    var username: String?
    var forum: Forum
    var message: Message
    var replies: [Message]
}
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("forums") { req -> Future<Response> in
        return Forum.query(on: req).all()
                .map(to: UserContext.self) { forums -> UserContext in
                    return UserContext( username: getUsername(req),forums: forums)
                }
                .encode(status: .ok, for: req)
    }
    
    router.group("forums",Int.parameter) { group in
        
        group.get("messages", use: { req -> Future<Response> in
           let forumId = try req.parameters.next(Int.self)
            return Forum.find(forumId, on: req).flatMap(to: Response.self) { forum in
                guard let forum = forum else { throw Abort(.notFound) }
                return Message.query(on: req)
                    .filter(\.forumId == forum.id!)
                    .filter(\.originId == 0)
                    .all()
                    .map {
                        return MessageContext(username: "enter-yang", forum: forum, messages: $0)
                }
                .encode(status: .ok, for: req)

            }
        })
        
        group.get("messages",Int.parameter) { req -> Future<Response> in  
            let fid = try req.parameters.next(Int.self)
            let mid = try req.parameters.next(Int.self)
            return Forum.find(fid, on: req).flatMap(to: Response.self) { forum in 
                guard let forum = forum else { throw Abort(.notFound) }
                
                return Message.find(mid, on: req).flatMap(to: Response.self) { message in
                    guard let message = message else { throw Abort(.notFound) }
                    
                    return Message.query(on: req)
                    .filter(\.originId == message.id!)
                    .all()
                    .map {
                         return ReplyContext(username: getUsername(req), forum: forum, message: message, replies: $0)
                    }
                    .encode(status: .ok, for: req)
                }
            }
        }
    }
}
