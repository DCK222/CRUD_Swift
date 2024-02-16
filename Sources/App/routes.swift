import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get(":id") { req -> EventLoopFuture<View> in
        // Intenta convertir la cadena en un UUID
        guard let vehiculoId = req.parameters.get("id"),
            let id = UUID(uuidString: vehiculoId) else {
            throw Abort(.badRequest)
        }
        
        return Vehiculo.find(id, on: req.db).flatMap { vehiculo in
            if let vehiculo = vehiculo {
                // Si se encuentra el vehículo, renderiza la vista con los datos del vehículo
                return req.view.render("index", [
                    "id": vehiculo.id?.uuidString ?? "",
                    "marca": vehiculo.marca,
                    "modelo": vehiculo.modelo,
                    "tipoDeCombustible" : vehiculo.tipoDeCombustible,
                    "pantallaCentral": vehiculo.pantallaCentral ? "Sí" : "No",
                    //"tamanoPantalla": vehiculo.tamañoPantalla != nil ? "\(vehiculo.tamañoPantalla!)" : "No especificado",
                    
                    
                    
                ])
            } else {
                // Si no se encuentra el vehículo, retorna un error 404 Not Found
                return req.eventLoop.future(error: Abort(.notFound))
            }
        }
    }

    try app.register(collection: VehiculoController())
}
