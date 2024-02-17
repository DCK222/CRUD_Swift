import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.get { req -> EventLoopFuture<View> in
        
        return req.view.render("indexre")
    }

    app.get(":id") { req -> EventLoopFuture<View> in
        
        guard let vehiculoId = req.parameters.get("id"),
            let id = UUID(uuidString: vehiculoId) else {
            throw Abort(.badRequest)
        }
        
        return Vehiculo.find(id, on: req.db).flatMap { vehiculo in
            if let vehiculo = vehiculo {
                
                return req.view.render("index", [
                    "id": vehiculo.id?.uuidString ?? "",
                    "marca": vehiculo.marca,
                    "modelo": vehiculo.modelo,
                    "tipoDeCombustible" : vehiculo.tipoDeCombustible,
                    "pantallaCentral": vehiculo.pantallaCentral ? "Sí" : "No",
                    
                    
                    
                    
                ])
            } else {
                
                return req.eventLoop.future(error: Abort(.notFound))
            }
        }
    }

    try app.register(collection: VehiculoController())
}
