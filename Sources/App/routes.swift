import Fluent
import Vapor
import Redis

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async throws -> String in
        return try await req.redis.ping().get()
    }
    
    app.middleware.use(LogMiddleware())
    app.middleware.use(AuthenticationMiddleware())
    
    try app.register(collection: Client.Controller())
    try app.register(collection: Owner.Controller())
    try app.register(collection: Car.Controller())
    try app.register(collection: Engine.Controller())
    try app.register(collection: Package.Controller())
    try app.register(collection: Pricing.Controller())
    try app.register(collection: RentalTransaction.Controller())
    try app.register(collection: Websocket.Controller())
}
