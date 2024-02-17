import Fluent

struct CrearVehiculo: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("vehiculos")
            .id()
            .field("marca", .string, .required)
            .field("modelo", .string, .required)
            .field("numero_de_ruedas", .int, .required)
            .field("tipo_de_combustible", .string, .required)
            .field("pantalla_central", .bool, .required)
            .field("tamaño_pantalla", .float) 
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("vehiculos").delete()
    }
}
