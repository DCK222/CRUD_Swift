import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        // Intenta convertir la cadena en un UUID
        guard let vehiculoId = UUID(uuidString: "FD8BA953-DDBA-400D-AD9F-221DCF29DE0E") else {
            // Si la cadena no es un UUID válido, retorna un error 400 Bad Request
            return req.eventLoop.future(error: Abort(.badRequest, reason: "ID de vehículo inválido"))
        }
        
        return Vehiculo.find(vehiculoId, on: req.db).flatMap { vehiculo in
            if let vehiculo = vehiculo {
                // Si se encuentra el vehículo, renderiza la vista con los datos del vehículo
                return req.view.render("index", [
                    "id": vehiculo.id?.uuidString ?? "",
                    "marca": vehiculo.marca,
                    "modelo": vehiculo.modelo,
                    
                ])
            } else {
                // Si no se encuentra el vehículo, retorna un error 404 Not Found
                return req.eventLoop.future(error: Abort(.notFound))
            }
        }
    }

    try app.register(collection: VehiculoController())
}
