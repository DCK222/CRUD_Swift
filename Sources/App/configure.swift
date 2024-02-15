import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor


public func configure(_ app: Application) async throws {
   

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "dbuser1",
        password: Environment.get("DATABASE_PASSWORD") ?? "12345",
        database: Environment.get("DATABASE_NAME") ?? "postgres",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUsuarios())
    app.migrations.add(UpdateTableUsuarios())


    try await app.autoMigrate() 

    app.views.use(.leaf)

      try routes(app)
}
