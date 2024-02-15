import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    // Configuración de la base de datos PostgreSQL
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "dbuser1",
        password: Environment.get("DATABASE_PASSWORD") ?? "12345",
        database: Environment.get("DATABASE_NAME") ?? "postgres",
        tls: .prefer(try .init(configuration: .clientDefault))
    )), as: .psql)

    // Configuración de migraciones: Asegúrate de reemplazar o eliminar migraciones no relacionadas y agregar las de vehículos
    // app.migrations.add(CreateTodo()) // Eliminar o comentar si no es necesario
    // app.migrations.add(CreateUsuarios()) // Eliminar o comentar si no es necesario
    // app.migrations.add(UpdateTableUsuarios()) // Eliminar o comentar si no es necesario
    app.migrations.add(CrearVehiculo()) // Asegúrate de tener esta migración para los vehículos

    // Ejecuta automáticamente las migraciones al iniciar la aplicación
    try await app.autoMigrate()

    // Configuración de vistas Leaf si es necesario para tu proyecto
    app.views.use(.leaf)

    // Registro de rutas
    try routes(app)
}
