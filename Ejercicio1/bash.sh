#!/bin/bash

menuRegistro() {

    #$1 contiene la opcion de registrar a un user o a un admin

    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        estadoCedula=255
        echo "Ingrese su usuario (x) para volver"
        read -p "-> " usuario

        estadoUsuario= verificarUser_Reg $usuario
        estadoUsuario=$?

        if [ $estadoUsuario -eq 1 ]
        then
            while [ $estadoCedula -eq 255 ]
            do
                clear
                estadoTelefono=255
                echo "Ingrese su cédula (x) para volver"
                read -p "-> " cedula

                estadoCedula= verificarCedula_Reg $cedula
                estadoCedula=$?

                if [ $estadoCedula -eq 1 ]
                then
                    while [ $estadoTelefono -eq 255 ]
                    do
                        clear
                        estadoFecha=255
                        echo "Ingrese su Telefono (x) para volver"
                        read -p "-> " telefono

                        estadoTelefono= verificarTel_Reg $telefono
                        estadoTelefono=$?

                        if [ $estadoTelefono -eq 1 ]
                        then
                            while [ $estadoFecha -eq 255 ]
                            do
                                clear
                                estadoContrasenia=255
                                echo "Ingrese su Fecha (x) para volver"
                                read -p "-> " fecha

                                estadoFecha= verificarFechaNac_Reg $fecha
                                estadoFecha=$?

                                if [ $estadoFecha -eq 1 ]
                                then
                                    while [ $estadoContrasenia -eq 255 ]
                                    do
                                        clear
                                        echo "Ingrese su Contrasenia (x) para volver"
                                        read -p "-> " contrasenia

                                        estadoContrasenia= verificarContra_Reg $contrasenia
                                        estadoContrasenia=$?
                                        
                                        if [ $estadoContrasenia -eq 1 ]
                                        then

                                            registrar $usuario $contrasenia $1 $cedula $telefono $fecha
                                                echo "Registrado"
                                            sleep 1
                                            volver=1

                                        elif [ $estadoContrasenia -eq 0 ]
                                        then
                                            estadoFecha=255
                                        fi
                                    done
                                elif [ $estadoFecha -eq 0 ]
                                then
                                    estadoTelefono=255
                                fi
                            done
                        elif [ $estadoTelefono -eq 0 ]
                        then
                            estadoCedula=255
                        fi
                    done
                fi
            done
        elif [ $estadoUsuario -eq 0 ]
        then
            volver=1
        fi
    done
}

registrar() {

    #$1 usuario
    #$2 contrasenia
    #$3 administrador o usuario
    #$4 cedula
    #$5 nro telefono
    #$6 fechaNac
    
    archivo=""
    if [ $3 -eq 2 ] 
    then
        archivo="./Users.txt"
    else
        archivo="./Admins.txt"
    fi
    echo "$1:$2:$4:+$5:$6" >> "$archivo"
    echo "" >> "$archivo"
}

verificarUser_Reg() {
    estado=-1

    #$1 usuario

    verificacion= verificarNum $1
    verificacion=$?

    if [ $1 == "x" ] || [ $1 == "X" ]
    then
        estado=0
    elif [ $verificacion -eq 1 ]
    then
        echo "El usuario debe contener al menos una letra "
        sleep 2
    elif  [ $1 == "" ]  || [[ $1 == *" "* ]] || [[ $1 == *":"* ]]
    then
        echo "Usuario inválido, el usuario no puede contener espacios o algún caracter seleccionado"
        sleep 2
    elif ! grep -Fq "$1:" "./Users.txt" && ! grep -Fq "$1:" "./Admins.txt"
    then
        estado=1
    else
        echo "Usuario ya existe"
        sleep 1
    fi
    return $estado
}

verificarCedula_Reg() {
    estado=-1

    #$1 cedula

    verificacion= verificarNum $1
    verificacion=$?

    if [ $1 == "x" ] || [ $1 == "X" ]
    then
        estado=0
    elif [ $verificacion -eq 1 ] && [ ${#1} -eq 8 ]
    then
        if ! grep -Fq ":$1:" "./Users.txt" && ! grep -Fq ":$1:" "./Admins.txt"
        then
            estado=1
        else
            echo "Esta cedula ya se ha utilizado"
            sleep 2
        fi
    else
        echo "Cedula invalida, tiene que tener largo 9 y debe incluir solo valores numericos"
        sleep 2
    fi
    return $estado
}

verificarTel_Reg() {
    estado=-1
    #$1 es el numero de Tel

    if [ $1 == "x" ] || [ $1 == "X" ]
    then
        estado=0
    else
        verificacion= verificarNum $1
        verificacion=$?
        if [ $verificacion -eq 1 ]
        then
            estado=1
        fi
    fi
    return $estado
}

verificarFechaNac_Reg() {
    estado=-1
    #$1 es la fecha

    if [ $1 == "x" ] || [ $1 == "X" ]
    then
        estado=0
    elif [[ $1 =~ ^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/(19[5-9][0-9]|20[0-1][0-9]|202[0-4])$ ]]
    then
        estado=1
    else
        echo "Escribir en formato adecuado dd/mm/yyyy"
        sleep 1
    fi
    return $estado
}

verificarContra_Reg() {
    estado=1
    #$1 es la contrasenia

    if [ "$1" = "x" ] || [ "$1" = "X" ]
    then
        estado=0
    fi
    return $estado
}

verificarNum() {
    #$1 es la variable a verificar
    valido=0
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        valido=1
    fi
    return $valido
}


verificarLoggeo() {
    clear
    valido=0
    
    #$1 usuario o cédula
    #$2 contrasenia
    
    if grep -Fq "$1:$2:" "./Admins.txt" || grep -Fq ":$2:$1:" "./Admins.txt"
    then
        valido=1  
    else
        if grep -Fq "$1:$2:" "./Users.txt" || grep -Fq ":$2:$1:" "./Users.txt" 
        then
            valido=2
        else
            echo "Usuario o Contraseña incorrectos"
            sleep 1
        fi
    fi
    
    return $valido
}



menuIniSesion() {
    clear
    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        echo "Ingrese su nombre de Usuario o Cédula (x) para volver"
        read -p "-> " usuario

        if [ "$usuario" = "x" ] || [ "$usuario" = "X" ]
        then
            volver=1
        else
            echo "Ingrese su contraseña (x) para volver"
            read -p "-> " contrasenia

            if [ ! "$contrasenia" = "x" ] && [ ! "$contrasenia" = "X" ]
            then
                verificar= verificarLoggeo $usuario $contrasenia
                verificar=$? 
                if [ $verificar -eq 1 ]
                then
                    menuAdmin
                elif [ $verificar -eq 2 ]
                then    
                    menuUser
                fi
            fi
        fi
    done
}

menuAdmin() {
    echo soy Admin
    sleep 2
}

menuUser() {
    echo soy el user, chele
    sleep 2
}

menuPrincipal() {
    salir=0

    while [ $salir -eq 0 ]
    do
        clear
        echo "Para iniciar sesion opción 1."
        echo "Para registrarse como usuario opción 2."
        echo "Para registrarse como Admin opción 3."
        echo "Para salir opcion 0."
        read -p "-> " opcion

        if [ $opcion -eq 0 ]
        then
            salir=1
        elif [ $opcion -eq 1 ]
        then
            menuIniSesion
            clear
        elif [[ $opcion -eq 2 || $opcion -eq 3 ]]
        then
            menuRegistro $opcion
        else
            clear
            echo "Opción no válida. Intente nuevamente."
            sleep 2
        fi

    done
    
}

menuPrincipal
clear
echo "chau mundo"
