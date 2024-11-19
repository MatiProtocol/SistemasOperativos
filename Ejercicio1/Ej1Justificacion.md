# CONSIDERACIONES EJERCICIO 1

### GENERAL
- En todo momento se puede retroceder al apartado anterior al colocar x en el flujo del programa. 


### CREAR CUENTAS:

- En ningún campo de la creación del usuario se premite ingresar caractéres por fuera de:
    - [(a-z), (A-Z), (0-9)] para el usuario.
    - [(0,9)] con cantidad total de 8 caracteres numericos para la cédula.
    - [(0,9)] para el teléfono.
    - [([0-2][0-9] || 3[0-1])/(0[1-9] || 1[0-2])/(19[5-9][0-9] || 20[0-1][0-9] || 202[0-4])] se permite poner fechas entre 01/01/1950 a 01/01/2024 para la fecha de nacimiento.
    - [todos los caracteres menos ":"] en la contraseña.

- A la hora de listar mascotas, optamos por mostrar todo lo mismo que se registra dado que para doptar se debe saber el id de la mascota. 

### INGRESAR MASCOTAS

- En ningún campo del ingreso se premite ingresar caractéres por fuera de:
    - [1-9] o [1-9] [0-9] para la edad.
    - [Macho, Hembra, macho, hembra] para el género
    - [(a-z) || [A-Z]] para el nombre y el tipo de mascota
    - [001 - 999] para el id
    - [todos los caracteres menos (-,/)] en la descripción, debido a que los datos guardados utilizan los caracteres "-" y "/". 

