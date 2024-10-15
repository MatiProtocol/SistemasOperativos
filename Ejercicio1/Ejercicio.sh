#!/bin/bash








registrar() {

    volver=0;
    read -p "U para cuenta de usuario. A cuenta de admin.\n" tipo 
    while ["$tipo" != "U" || "$tipo" != "A"] do
        if ["$tipo" == "U"]; then
            archivo="./Client_Users.txt"
        # Ruta al archivo de usuarios
        else if ["$tipo" == "A"]; then
            archivo="./Admin_Users.txt"
        else 
            echo "Ingrese una opcion valida."
            read -p "U para cuenta de usuario. A cuenta de admin.\n" tipo
        fi
        
    end while;
    
    read -p "Introduce el nombre de usuario o (x) para volver: " usuario
    while ["$usuario" != x || "$usuario" != X] do
        if grep -q "^$usuario:" "./Client_Users" || grep -q "^$usuario:" "./Admin_Users"
            echo "Error: El usuario '$usuario' ya existe."
            read -p "Introduce el nombre de usuario o (x) para volver: " usuario
            
    end while;

    # Comprobar si el usuario ya existe
    #if grep -q "^$usuario:" "./Client_Users" || grep -q "^$usuario:" "./Admin_Users" ; then
    #    echo "Error: El usuario '$usuario' ya existe."
    #    exit 1
    #fi

    # Solicitar contraseña de forma segura
    read -p "Introduce la contraseña: " contrasena
    echo  # Salto de línea después de la contraseña

    # Registrar el usuario (agregar al archivo)
    echo "$usuario:$contrasena" >> "$archivo"
    echo "Usuario registrado exitosamente."
}

iniciar_sesion(){
    # Ruta al archivo de usuarios
    archivo_clientes="./Admin_Users.txt"
    archivo_admins="./Client_Users.txt"

    # Solicitar credenciales
    read -p "Introduce tu usuario: " usuario
    read -p "Introduce tu contraseña: " contrasena
    echo  # Para saltar de línea tras ingresar la contraseña

    # Buscar usuario y contraseña en el archivo
    credencial="$usuario:$contrasena"

    # Verificar si la credencial está en el archivo
    if grep -q "^$credencial$" "$archivo_clientes"; then
        echo "Autenticación exitosa. Bienvenido, $usuario!"
    else if then
    
        #echo "Error: Usuario o contraseña incorrectos."
        grep -q "^$credencial$" "$archivo_admins"

    else echo "Error: Usuario o contraseña incorrectos."
    fi
}