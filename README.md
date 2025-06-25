# 🧾 Sistema de Seguimiento de la Cadena de Suministro

Contrato inteligente desarrollado en Solidity para permitir a empresas y consumidores rastrear el origen y las etapas de la cadena de suministro de productos. Este proyecto fue creado como trabajo final del curso “Introducción al Desarrollo de Smart Contracts” (UNRN, 2023).

## 📌 Descripción

Este contrato permite a múltiples empresas registrar productos y gestionar su avance por distintas etapas del ciclo de suministro:

- 🛠️ Planificación  
- 📦 Abastecimiento  
- 🏭 Fabricación  
- 🚚 Entrega  
- 🔁 Devolución  

Cada empresa puede registrar, consultar y actualizar exclusivamente sus propios productos, lo cual asegura la privacidad y trazabilidad dentro del ecosistema del contrato.

## ✨ Funcionalidades principales

- Registro único de productos por empresa.
- Avance de etapa controlado y secuencial.
- Restricción de acceso por propietario del producto.
- Consulta pública de datos registrados.

## 🧱 Estructura del contrato

### `Producto`

Cada producto registrado contiene:

- `nombre`: Nombre del producto  
- `origen`: Lugar de origen  
- `fechaFabricacion`: Fecha cuando se fabricó  
- `fechaEntrega`: Fecha de entrega al consumidor  
- `fechaDevolucion`: Fecha de devolución (si corresponde)  
- `etapa`: Etapa actual del producto  
- `idProducto`: Identificador único por empresa  

### `Etapa` (enum)

Representa la etapa actual del producto:  
`Planificacion` → `Abastecimiento` → `Fabricacion` → `Entrega` → `Devolucion`

## 🔐 Seguridad y control

- Modificadores como `existe`, `noExiste` y `etapaCorrecta` aseguran un flujo lógico válido.
- Solo la empresa que registró el producto puede modificarlo.
- La información no se puede sobrescribir fuera de secuencia.

## 🚀 Cómo probarlo

1. Usar [Remix IDE](https://remix.ethereum.org/)
2. Crear un nuevo archivo `.sol` y pegar el código del contrato.
3. Compilar con la versión 0.8.0 o superior.
4. Desplegar en entorno JavaScript VM.
5. Probar funciones con distintas direcciones y valores.

## 📄 Licencia

MIT License.

## 👨‍💻 Autor

David Rodríguez  
[LinkedIn](https://www.linkedin.com/in/david-rodr%C3%ADguez-530327222/) – [GitHub](https://github.com/RoDavid4)

