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
            if ! grep -Fq "$usuario:" "./Users.txt" && ! grep -Fq "$usuario:" "./Admins.txt"; 
            then
                contrasenia=""
                while [ "$contrasenia" != "x" ] && [ "$contrasenia" != "X" ]
                do
                    echo "Ingrese su contraseña (x) para volver"
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
            else
                clear
                echo "El usuario ya existe" 
                sleep 1
            fi
        fi
        clear
    done
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
    
    archivo=""
    if [ $3 -eq 2 ] 
    then
        archivo="./Users.txt"
    else
        archivo="./Admins.txt"
    fi
    echo "$1:$2" >> "$archivo"
    
}

menuPrincipal
clear
echo "chau mundo"
