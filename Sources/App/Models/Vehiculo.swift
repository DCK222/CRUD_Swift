import Fluent
import Vapor

final class Vehiculo: Model, Content {
    static let schema = "vehiculos"

    @ID(key: .id) var id: UUID?
    @Field(key: "marca") var marca: String
    @Field(key: "modelo") var modelo: String
    @Field(key: "numero_de_ruedas") var numeroDeRuedas: Int
    @Field(key: "tipo_de_combustible") var tipoDeCombustible: String
    @Field(key: "pantalla_central") var pantallaCentral: Bool
    @OptionalField(key: "tamaño_pantalla") var tamañoPantalla: Float?

    init() {}

    init(id: UUID? = nil, marca: String, modelo: String, numeroDeRuedas: Int, tipoDeCombustible: String, pantallaCentral: Bool, tamañoPantalla: Float?) {
        self.id = id
        self.marca = marca
        self.modelo = modelo
        self.numeroDeRuedas = numeroDeRuedas
        self.tipoDeCombustible = tipoDeCombustible
        self.pantallaCentral = pantallaCentral
        self.tamañoPantalla = tamañoPantalla
    }
}

extension Vehiculo {
    struct ActualizarVehiculo: Content {
        var marca: String
        var modelo: String
        var numeroDeRuedas: Int
        var tipoDeCombustible: String
        var pantallaCentral: Bool
        var tamañoPantalla: Float?
    }
}
