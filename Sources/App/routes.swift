import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    try app.register(collection: Client.Controller())
    try app.register(collection: Owner.Controller())
    try app.register(collection: Car.Controller())
    try app.register(collection: Engine.Controller())
    try app.register(collection: Coordinates.Controller())
    try app.register(collection: Package.Controller())
    try app.register(collection: Pricing.Controller())
    try app.register(collection: RentalTransaction.Controller())
}
