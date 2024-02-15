import Fluent
import Vapor

struct VehiculoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("apiVehiculos")

        api.post("crearVehiculo", use: crearVehiculo)
        api.get("obtenerVehiculos", use: obtenerVehiculos)
        api.get("obtenerVehiculo", ":id", use: obtenerVehiculo)
        api.delete("eliminarVehiculo", ":id", use: eliminarVehiculo)
        api.put("actualizarVehiculo", ":id", use: actualizarVehiculo)
    }

    func actualizarVehiculo(req: Request) async throws -> Vehiculo {
        guard let id = req.parameters.get("id", as: UUID.self),
              let actualizarVehiculo = try? req.content.decode(Vehiculo.ActualizarVehiculo.self) else {
                throw Abort(.badRequest, reason: "Datos de la solicitud inválidos")
            }

        guard let vehiculo = try await Vehiculo.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "No existe vehículo con ese ID")
        }

        vehiculo.marca = actualizarVehiculo.marca
        vehiculo.modelo = actualizarVehiculo.modelo
        vehiculo.numeroDeRuedas = actualizarVehiculo.numeroDeRuedas
        vehiculo.tipoDeCombustible = actualizarVehiculo.tipoDeCombustible
        vehiculo.pantallaCentral = actualizarVehiculo.pantallaCentral
        vehiculo.tamañoPantalla = actualizarVehiculo.tamañoPantalla

        try await vehiculo.update(on: req.db)
        return vehiculo
    }

    func eliminarVehiculo(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.notFound, reason: "No existe vehículo con ese ID")
        }

        if let vehiculo = try await Vehiculo.find(id, on: req.db) {
            try await vehiculo.delete(on: req.db)
            return .ok
        } else {
            throw Abort(.notFound)
        }
    }

    func obtenerVehiculo(req: Request) async throws -> Vehiculo {
        guard let id = req.parameters.get("id", as: UUID.self),
              let vehiculo = try await Vehiculo.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "No existe vehículo con ese ID")
        }
        return vehiculo
    }

    func obtenerVehiculos(req: Request) async throws -> [Vehiculo] {
        try await Vehiculo.query(on: req.db).all()
    }

    func crearVehiculo(req: Request) async throws -> Vehiculo {
        let vehiculo = try req.content.decode(Vehiculo.self)
        try await vehiculo.create(on: req.db)
        return vehiculo
    }
}
