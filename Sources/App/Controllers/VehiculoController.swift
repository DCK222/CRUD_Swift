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
        api.get("obtenerPorModelo", ":modelo", use: obtenerPorModelo)
        api.get("obtenerPorMarca", ":marca", use: obtenerPorMarca)
        api.get("obtenerPorNumeroDeRuedas", ":numeroDeRuedas", use: obtenerPorNumeroDeRuedas)
        api.get("obtenerPortipoDeCombustible", ":tipoDeCombustible", use: obtenerPortipoDeCombustible)
        api.get("obtenerPorPantallaCentral", ":pantallaCentral", use: obtenerPorPantallaCentral)
        api.get("obtenerPorTamañoPantalla", ":tamañoPantalla", use: obtenerPorTamañoPantalla)

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
    func obtenerPorModelo(req: Request) async throws -> [Vehiculo] {
        guard let modelo = req.parameters.get("modelo") else {
            throw Abort(.badRequest, reason: "Se necesita especificar un modelo")
        }

        // Utiliza una consulta para filtrar vehículos por el campo del modelo
        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$modelo == modelo).all()
        return vehiculos
    }
    func obtenerPorMarca(req: Request) async throws -> [Vehiculo] {
        guard let marca = req.parameters.get("marca") else {
            throw Abort(.badRequest, reason: "Se necesita especificar un modelo")
        }

        // Utiliza una consulta para filtrar vehículos por el campo del modelo
        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$marca == marca).all()
        return vehiculos
    }
    func obtenerPorNumeroDeRuedas(req: Request) async throws -> [Vehiculo] {
        guard let numeroDeRuedasString = req.parameters.get("numeroDeRuedas"),
              let numeroDeRuedas = Int(numeroDeRuedasString) else {
            throw Abort(.badRequest, reason: "Se necesita especificar el número de ruedas como un entero")
        }

        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$numeroDeRuedas == numeroDeRuedas).all()
        return vehiculos
    }
    func obtenerPortipoDeCombustible(req: Request) async throws -> [Vehiculo] {
        guard let tipoDeCombustible = req.parameters.get("tipoDeCombustible") else {
            throw Abort(.badRequest, reason: "Se necesita especificar un modelo")
        }

        // Utiliza una consulta para filtrar vehículos por el campo del modelo
        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$tipoDeCombustible == tipoDeCombustible).all()
        return vehiculos
    }

      func obtenerPorPantallaCentral(req: Request) async throws -> [Vehiculo] {
        guard let pantallaCentralString = req.parameters.get("pantallaCentral"),
              let pantallaCentral = Bool(pantallaCentralString) else {
            throw Abort(.badRequest, reason: "Se necesita especificar 'pantallaCentral' como true o false")
        }

        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$pantallaCentral == pantallaCentral).all()
        return vehiculos
    }

    func obtenerPorTamañoPantalla(req: Request) async throws -> [Vehiculo] {
        guard let tamañoPantallaString = req.parameters.get("tamañoPantalla"),
              let tamañoPantalla = Float(tamañoPantallaString) else {
            throw Abort(.badRequest, reason: "Se necesita especificar 'tamañoPantalla' como un número")
        }

        let vehiculos = try await Vehiculo.query(on: req.db).filter(\.$tamañoPantalla == tamañoPantalla).all()
        return vehiculos
    }
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
