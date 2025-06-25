// SPDX-License-Identifier: MIT

/** 
* @title Sistema de seguimiento de la cadena de suministro
* @autor Rodriguez David

Propuesta:   Crea un contrato inteligente que permita a las empresas y consumidores
             rastrear el origen y la cadena de suministro de productos.

Descripcion: Las empresas pueden registrar información sobre un producto específico,
             como su origen, fecha de fabricación y etapas de la cadena de suministro.
             Los consumidores pueden escanear un código en el producto para acceder
             a la información almacenada en el contrato. El contrato debe garantizar que
             la información registrada no se pueda modificar o eliminar.
*/

pragma solidity >=0.8.2 <0.9.0;

enum Etapa {
    Planificacion,   // 0
    Abastecimiento,  // 1
    Fabricacion,     // 2
    Entrega,         // 3
    Devolucion       // 4
}

struct Producto {
    string nombre;
    string origen;
    string fechaFabricacion;
    string fechaEntrega;
    string fechaDevolucion;
    Etapa etapa;
    uint16 idProducto;
}

contract CadenaDeSuministro {
    mapping (address => mapping  (uint16 => Producto)) productos; 
    // se busca por [empresa][codigo], esto es para que el contrato sirva para multiples empresas
    
    constructor() {}
/**
* @dev se requieren modificadores para controlar que un producto ya exista en caso de querer
       verlo o modificarlo y tambien en el caso de que un producto no deba de existir como es
       en el caso de querer cargar un nuevo producto
*/

modifier existe (address _address, uint16 _id) {
    
    require (keccak256(abi.encodePacked(productos[_address][_id].nombre)) != 
                        keccak256(abi.encodePacked("")), "No existe un producto con ese codigo");
    _;
}

modifier noExiste (uint16 _id) {
    require (keccak256(abi.encodePacked(productos[msg.sender][_id].nombre)) == 
                        keccak256(abi.encodePacked("")), "Ya existe un producto con ese codigo");
    _;
}

modifier etapaCorrecta (Etapa _etapa, uint16 _id) {
    require (_etapa == productos[msg.sender][_id].etapa, "No se puede actualizar a la etapa elegida");
    _;
}

event verProducto(Producto _producto, string mensaje);

/**
* @notice funciones para la carga y el seteo de las distintas etapas de la cadena de suministro
          las actualizaciones de productos solo pueden ser realizadas por la empresa que cargo el 
          producto.

* @dev si bien puede parecer que son muchas funciones que hacen cosas similares la idea es que
       en cada etapa se realizan diferentes actividades, seguramente en la practica en cada etapa
       se debería de registarar mas informacion o de realizar llamados a funciones dentro o fuera
       del mismo contrato, es por eso que se realizan de manera individual, otra manera seria
       marcar las funciones de etapas como privadas y generar una funcion publica "avanzar etapa" 
       que dentro de la misma utilizar las funciones existentes segun corresponda.  
*/

function planificarProducto(uint16 _id, string memory _nombre, string memory _origen) public noExiste(_id) {
    Producto memory producto;
        producto.nombre = _nombre;
        producto.origen = _origen;
        producto.etapa = Etapa.Planificacion;
        producto.idProducto = _id;

    productos[msg.sender][_id] = producto;
    emit verProducto(producto, "Producto en etapa de Planificacion");
}

function abastecerProducto(uint16 _id) public existe(msg.sender, _id) etapaCorrecta(Etapa.Planificacion, _id) {
    productos[msg.sender][_id].etapa = Etapa.Abastecimiento;
    emit verProducto(productos[msg.sender][_id], "Producto en etapa de Abastecimiento");
    
}

function fabricarProducto(uint16 _id, string memory _fecha) public existe(msg.sender, _id) etapaCorrecta(Etapa.Abastecimiento, _id) {
    productos[msg.sender][_id].etapa = Etapa.Fabricacion;  
    productos[msg.sender][_id].fechaFabricacion = _fecha;
    emit verProducto(productos[msg.sender][_id], "Producto en etapa de Fabricacion");
}

function entregarProducto(uint16 _id, string memory _fecha) public existe(msg.sender, _id) etapaCorrecta(Etapa.Fabricacion, _id) {
    productos[msg.sender][_id].etapa = Etapa.Entrega;
    productos[msg.sender][_id].fechaEntrega = _fecha;
    emit verProducto(productos[msg.sender][_id], "Producto en etapa de Entrega");
}

function devolucionProducto(uint16 _id, string memory _fecha) public existe(msg.sender, _id) etapaCorrecta(Etapa.Entrega, _id) {
    productos[msg.sender][_id].etapa = Etapa.Devolucion;
    productos[msg.sender][_id].fechaDevolucion = _fecha;
    emit verProducto(productos[msg.sender][_id], "Producto en etapa de Devolucion");
}

function buscarProducto(address _address, uint16 _id) public view existe(_address, _id) returns (Producto memory) {

    return productos[_address][_id];
}

}