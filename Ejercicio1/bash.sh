#!/bin/bash

menuRegistro() {
    clear
    volver=0
    while [ $volver -eq 0 ]
    do
        echo "Ingrese su nombre de Usuario (x) para volver"
        read -p "-> " usuario 
        
        if [ "$usuario" = "x" ] || [ "$usuario" = "X" ]
        then
            volver=1
        else
            verificacion= VerificarUsuario $usuario
            verificacion=$?
            if [ $verificacion -eq 1 ]
            then
                contrasenia=""
                while [ "$contrasenia" != "x" ] && [ "$contrasenia" != "X" ]
                do
                    echo "Ingrese su contraseña, (x) para volver"
                    read -p "-> " contrasenia
                    if [ "$contrasenia" != "x" ] && [ "$contrasenia" != "X" ] 
                    then
                        registrar $usuario $contrasenia $opcion
                        echo "Usuario registrado"
                        sleep 2
                        contrasenia="x"
                        volver=1
                    fi
                done
            fi
        fi
        clear
    done
}

VerificarUsuario() {
    clear
    valido=0
    
    #$1 usuario
    if [[ $1 != "" ]] && [[ $1 != *" "* ]] && [[ $1 != *":"* ]] && [[ $1 != *"Anuar"* ]] #es una joda q>:P
     then
        if ! grep -Fq "$1:" "./Users.txt" && ! grep -Fq "$1:" "./Admins.txt"
        then
            valido=1
        else
            echo "Usuario ya existe"
            sleep 1
        fi
    else
        echo "Usuario inválido, el usuario no puede contener espacios o algún caracter seleccionado"
        sleep 2
    fi
    
    return $valido
}

menuPrincipal() {
    clear
    salir=0

    while [ $salir -eq 0 ]
    do
        echo "Para iniciar sesion opción 1."
        echo "Para registrarse como usuario opción 2."
        echo "Para registrarse como Admin opción 3."
        echo "Para salir opcion 0."
        read -p "-> " opcion

        if [[ $opcion -eq 0 ]]
        then
            salir=1
        elif [[ $opcion -eq 2 || $opcion -eq 3 ]]
        then
            menuRegistro $opcion $salir
        else
            clear
            echo "Opción no válida. Intente nuevamente."
            sleep 2
        fi

    done
    
}

registrar() {
    
    #$1 usuario
    #$2 contrasenia
    #$3 administrador o usuario

    archivo=""
    if [ $3 -eq 2 ] 
    then
        archivo="./Users.txt"
    else
        archivo="./Admins.txt"
    fi
    echo "$1:$2" >> "$archivo"
    echo "" >> "$archivo"
    
}

menuPrincipal
clear
echo "chau mundo"
