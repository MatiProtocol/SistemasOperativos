#!/bin/bash

menuRegistro() {

    #$1 contiene la opcion de registrar a un user o a un admin

    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        estadoCedula=255
        echo "Ingrese el usuario, (x) para volver"
        read -rp "-> " usuario

        verificarUser_Reg "$usuario"
        estadoUsuario=$?

        if [ $estadoUsuario -eq 1 ]
        then
            while [ $estadoCedula -eq 255 ]
            do
                clear
                estadoTelefono=255
                echo "Ingrese la cédula, (x) para volver"
                read -rp "-> " cedula

                verificarCedula_Reg "$cedula"
                estadoCedula=$?

                if [ $estadoCedula -eq 1 ]
                then
                    while [ $estadoTelefono -eq 255 ]
                    do
                        clear
                        estadoFecha=255
                        echo "Ingrese el Telefono, (x) para volver"
                        read -rp "-> " telefono

                        verificarTel_Reg "$telefono"
                        estadoTelefono=$?

                        if [ $estadoTelefono -eq 1 ]
                        then
                            while [ $estadoFecha -eq 255 ]
                            do
                                clear
                                estadoContrasenia=255
                                echo "Ingrese la Fecha de nacimiento, (x) para volver"
                                read -rp "-> " fecha

                                verificarFecha_Reg "$fecha"
                                estadoFecha=$?

                                if [ $estadoFecha -eq 1 ]
                                then
                                    while [ $estadoContrasenia -eq 255 ]
                                    do
                                        clear
                                        echo "Ingrese la Contraseña, (x) para volver"
                                        read -rp "-> " contrasenia

                                        verificarContra_Reg "$contrasenia"
                                        estadoContrasenia=$?
                                        
                                        if [ $estadoContrasenia -eq 1 ]
                                        then

                                            registrar "$usuario" "$contrasenia" "$1" "$cedula" "$telefono" "$fecha"
                                                echo "Registrado"
                                            sleep 2
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

menuRegistrarMascotas() {
    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        estadoTipoMasc=255
        echo "Ingrese número Identificador, (x) para volver"
        read -rp "-> " nroId

        verificarNroId_Reg "$nroId"
        estadoId=$?

        if [ $estadoId -eq 1 ]
        then
            while [ $estadoTipoMasc -eq 255 ]
            do
                clear
                estadoNombMasc=255
                echo "Ingrese el tipo de animal, (x) para volver"
                read -rp "-> " tipoMasc

                verificarCadenaTexto "$tipoMasc"
                estadoTipoMasc=$?

                if [ $estadoTipoMasc -eq 1 ]
                then
                    while [ $estadoNombMasc -eq 255 ]
                    do
                        clear
                        estadoGeneroMasc=255
                        echo "Ingrese el nombre de la mascota, (x) para volver"
                        read -rp "-> " nombMasc

                        verificarCadenaTexto "$nombMasc"
                        estadoNombMasc=$?

                        if [ $estadoNombMasc -eq 1 ]
                        then
                            while [ $estadoGeneroMasc -eq 255 ]
                            do
                                clear
                                estadoEdadMasc=255
                                echo "Ingrese genero de la mascota: Macho o Hembra, (x) para volver"
                                read -rp "-> " generoMasc

                                verificarGeneroMasc_Reg "$generoMasc"
                                estadoGeneroMasc=$?

                                if [ $estadoGeneroMasc -eq 1 ]
                                then
                                    while [ $estadoEdadMasc -eq 255 ]
                                    do
                                        clear
                                        estadoDescripcion=255
                                        echo "Ingrese edad de la mascota, (x) para volver"
                                        read -rp "-> " edadMasc
                                        
                                        verificarEdadMasc_Reg "$edadMasc"
                                        estadoEdadMasc=$?

                                        if [ $estadoEdadMasc -eq 1 ]
                                        then
                                            while [ $estadoDescripcion -eq 255 ]
                                            do
                                                clear
                                                echo "Ingrese Descripcion de la mascota, (x) para volver"
                                                read -rp "-> " descMasc

                                                verificarDescripcion_Reg "$descMasc"
                                                estadoDescripcion=$?

                                                if [ $estadoDescripcion -eq 1 ]
                                                then
                                                    regMascota "$nroId" "$tipoMasc" "$nombMasc" "$generoMasc" "$edadMasc" "$descMasc"
                                                    echo "Se registro la mascota"
                                                    sleep 2
                                                    volver=1
                                                elif [ $estadoDescripcion -eq 0 ]
                                                then
                                                    estadoEdadMasc=255
                                                fi
                                            done
                                        elif [ $estadoEdadMasc -eq 0 ]
                                        then
                                            estadoGeneroMasc=255
                                        fi
                                    done
                                elif [ $estadoGeneroMasc -eq 0 ]
                                then
                                    estadoNombMasc=255
                                fi
                            done
                        elif [ $estadoNombMasc -eq 0 ]
                        then
                            estadoTipoMasc=255
                        fi
                    done
                fi
            done
        elif [ $estadoId -eq 0 ]
        then
            volver=1
        fi
    done
}

verificarEdadMasc_Reg() {
    estado=-1

    #$1 edad Mascota

    verificarNumPos "$1"
    verificacion=$?

    if [ "$1" = "x" ] || [ "$1" == "X" ]
    then
        estado=0
    elif [[ "$1" =~ ^[1-9]+$ ]] || [[ "$1" =~ ^[1-9][0-9]+$ ]]
    then
        if [ $1 -gt 1 ]
        then
            estado=1
        else
            estado=-1
            echo "La edad debe ser mayor a 1 "
            sleep 2
        fi
    else
        echo "La edad debe contener solo números sin ceros en la izquierda"
        estado=-1
        sleep 3
    fi

    return $estado
}

verificarGeneroMasc_Reg() {
    estado=-1

    #$1 genero

    verificarNoEspacio "$1"
    noEspacio=$?

    if [ $noEspacio -eq 1 ]
    then
        if [ "$1" = "x" ] || [ "$1" == "X" ]
        then
            estado=0
        elif [ "$1" = "Macho" ] || [ "$1" = "Hembra" ] || [ "$1" = "macho" ] || [ "$1" = "hembra" ]
        then
            estado=1
        else
            echo "opción invalida"
            estado=-1
            sleep 2
        fi
    fi
    return $estado
}

verificarDescripcion_Reg() {
    estado=-1
    if [ "$1" = "x" ] || [ "$1" == "X" ]
    then
        estado=0
    elif [[ "$1" != *"-"* ]] && [[ "$1" != *"/"* ]] && [ ! -z "$1" ]
    then
        estado=1
    else
        echo "El dato no debe contener numeros o caracteres especiales"
        sleep 3
        estado=-1
    fi
    return $estado
}

verificarCadenaTexto() {
    estado=-1

    #$1 cadena de texto

    verificarNoEspacio "$1"
    noEspacio=$?

    if [ $noEspacio -eq 1 ]
    then
        if [ "$1" = "x" ] || [ "$1" == "X" ]
        then
            estado=0
        elif [[ "$1" =~ ^([a-z]|[A-Z])+$  ]] && [ ! -z "$1" ]
        then
            estado=1
        else
            echo "El dato no debe contener numeros o caracteres especiales"
            sleep 3
            estado=-1
        fi
    fi
    return $estado
}

verificarNroId_Reg() {
   estado=-1

    #$1 Nro mascota

    verificarNumPos $1
    verificacion=$?

    if [ "$1" = "x" ] || [ "$1" == "X" ]
    then
        estado=0
    elif [ $verificacion -eq 1 ] && [ ${#1} -eq 3 ]
    then
        if [ "$1" == "000" ]
        then
            estado=-1
            echo " El Id no puede ser 000 "
            sleep 2
        else
            if ! grep -q "^$1-" "./MascotasAdopcion.txt"
            then
                estado=1
            else
                estado=-1
                echo "Este Id ya se ha utilizado"
                sleep 2
            fi
        fi
    else
        echo "Id invalida, tiene que tener largo 3 y debe incluir solo valores númericos. Ej: 001"
        estado=-1
        sleep 3
    fi
    return $estado
}

verificarUser_Reg() {
    estado=-1

    #$1 usuario
    verificarNoEspacio "$1"
    noEspacio=$?
    
    if [ $noEspacio -eq 1 ]
    then
        verificarNumPos "$1"
        verificacion=$?

        if [ "$1" = "x" ] || [ "$1" = "X" ] 
        then
            estado=0
        elif [ $verificacion -eq 1 ]
        then
            echo "El usuario debe contener al menos una letra"
            estado=-1
            sleep 2
        elif [[ ! "$1" =~ ^([a-z]|[A-Z]|[0-9])+$ ]] || [  -z "$1" ]
        then
            echo "Usuario inválido, el usuario no debe tener caracter seleccionado"
            estado=-1
            sleep 3
        elif ! grep -q "$1:" "./Users.txt" && ! grep -q "$1:" "./Admins.txt"
        then
            estado=1
        else
            echo "Usuario ya existe"
            estado=-1
            sleep 2
        fi
    fi
    return $estado
}

verificarCedula_Reg() {
    estado=-1

    #$1 cedula

    verificarNumPos "$1"
    verificacion=$?

    if [ "$1" = "x" ] || [ "$1" == "X" ]
    then
        estado=0
    elif [ $verificacion -eq 1 ] && [ ${#1} -eq 8 ]
    then
        if ! grep -q ":$1:" "./Users.txt" && ! grep -q ":$1:" "./Admins.txt"
        then
            estado=1
        else
            echo "Esta cedula ya se ha utilizado"
            estado=-1
            sleep 2
        fi
    else
        echo "Cedula invalida, tiene que tener largo 8 y debe incluir solo valores númericos"
        estado=-1
        sleep 3
    fi
    return $estado
}

verificarTel_Reg() {
    estado=-1
    #$1 es el numero de Tel

    verificarNumPos "$1"
    verificacion=$?

    if [ "$1" = "x" ] || [ "$1" == "X" ]
    then
        estado=0
        
    elif [ $verificacion -eq 1 ]
    then
        estado=1
    else
        echo "Telefono invalido, solo debe incluir valores númericos"
        estado=-1
        sleep 2
    fi
    return $estado
}

verificarFecha_Reg() {
    estado=-1
    #$1 es la fecha

    if [ "$1" = "x" ] || [ "$1" = "X" ]
    then
        estado=0
    elif [[ "$1" =~ ^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/(19[5-9][0-9]|20[0-1][0-9]|202[0-4])$ ]]
    then
        estado=1
    else
        echo "Escribir en formato adecuado dd/mm/yyyy"
        echo "La fecha debe estar entre 1950 y 2024"
        sleep 4
    fi
    return $estado
}

verificarContra_Reg() {
    estado=1
    #$1 es la contrasenia

    verificarNoEspacio "$1"
    noEspacio=$?

    if [ "$1" = "x" ] || [ "$1" = "X" ]
    then
        estado=0
    else
        if [ $noEspacio -eq -1 ] 
        then
            if [[ "$1" == *":"* ]]
            then
                echo "La contraseña no puede contener :."
                sleep 2
                estado=-1
            else
                estado=1
            fi
        fi
    fi
    return $estado
}

verificarNumPos() {
    #$1 es la variable a verificar
    estado=0
    if [[ "$1" =~ ^[0-9]+$ ]]
    then
        estado=1
    fi
    return $estado
}


verificarLoggeo() {
    clear
    estado=0
    
    #$1 usuario o cédula
    #$2 contrasenia
    
    if grep -q "$1:$2:" "./Admins.txt" || grep -q ":$2:$1:" "./Admins.txt"
    then
        estado=1  
    else
        if grep -q "$1:$2:" "./Users.txt" || grep -q ":$2:$1:" "./Users.txt" 
        then
            estado=2
        else
            echo "Usuario o Contraseña incorrectos"
            sleep 2
        fi
    fi
    
    return $estado
}

registrar() {

    #$1 usuario
    #$2 contrasenia
    #$3 administrador o usuario
    #$4 cedula
    #$5 nro telefono
    #$6 fechaNac
    
    archivo=""
    if [ $3 -eq 1 ] 
    then
        archivo="./Users.txt"
    else
        archivo="./Admins.txt"
    fi
    echo "$1:$2:$4:+$5:$6" >> "$archivo"
    echo "" >> "$archivo"
}


menuEstadisticas() {
    clear
    volver=0
    while [ $volver -eq 0 ]
    do
        vals=$(awk '{print $1}' "./adopciones.txt")
        if [ ! -z "$vals" ]
        then
            promedioEdadMescota
            echo ""
            mesMasAdoptadas
            echo ""
            promedioTipoNombMascota
        else
            echo "No hay animales adoptados aún."
        fi
        
        echo ""
        echo "(x) para volver atrás." 
        read -rp "-> " atras
        if [ "$atras" == "x" ] || [ "$atras" == "X" ]
        then    
            volver=1
        fi
    done
    return $volver   
}

mesMasAdoptadas() {
    meses=$(awk -F'/' '{print $2}' "./adopciones.txt")
    if [ ! -z "$meses" ]
    then
        declare -A contador_meses

        for mes in $meses
        do
            ((contador_meses[$mes]++))
        done

        max_frecuencia=0
        mes_mas_frecuente=""

        for mes in "${!contador_meses[@]}"
        do
            if (( contador_meses[$mes] > max_frecuencia ))
            then
                max_frecuencia=${contador_meses[$mes]}
                mes_mas_frecuente=$mes
            fi
        done
        echo "El mes más frecuente es: " "$mes_mas_frecuente"
    fi
    
}

promedioTipoNombMascota() {

    tiposAdoptados=$(awk -F'-' '{print $1}' "./adopciones.txt")
    tiposAdopcion=$(awk -F'-' '{print $2}' "./MascotasAdopcion.txt")
    tipoTotalSinRep=$(echo "$tiposAdoptados"$'\n'"$tiposAdopcion" | sort | uniq)
    tipoTotalConRep=$(echo "$tiposAdoptados"$'\n'"$tiposAdopcion")
    
    totalGeneral=0
    totalAdoptados=0

    for tipo in $tipoTotalSinRep
    do
        for tipoAux in $tipoTotalConRep
        do
            if [ $tipo == $tipoAux ]
            then
                totalGeneral=$((totalGeneral + 1 ))
            fi
        done

        for tipoAux in $tiposAdoptados
        do
            if [ $tipo == $tipoAux ]
            then
                totalAdoptados=$((totalAdoptados + 1 ))
            fi
        done
        echo "El porcentaje del tipo $tipo adoptados es de: "$((((totalAdoptados * 100) / totalGeneral)))"%"
        totalGeneral=0
        totalAdoptados=0
    done

}

promedioEdadMescota() {
    
    vals=$(awk -F'-' '{print $4}' "./adopciones.txt")
    if [ ! -z "$vals" ]
    then
        i=0
        for val in $vals
        do
            i=$((i + 1))
            sumaEdad=$((sumaEdad + val))
        done
        echo "Promedio de la edad de los animales adoptados: " $((sumaEdad / i))
    fi
}

regMascota() {

    #$1 nroId
    #$2 tipoMasc
    #$3 edadMasc
    #$4 generoMasc
    #$5 nombMasc
    #$6 descMasc
    
    fecha=$(date +"%d/%m/%Y")

    nombMinsculas=$(echo "$2" | tr '[:upper:]' '[:lower:]')
    generoMinusculas=$(echo "$4" | tr '[:upper:]' '[:lower:]')
    echo "$1-$nombMinsculas-$3-$generoMinusculas-$5-$6-$fecha" >> "./MascotasAdopcion.txt"

}

verificarNoEspacio() {
    estado=-1
    if [[ "$1" == *" "* ]] || [[ "$1" == "" ]] 
    then
        echo "Error, la entrada contiene espacios."
        sleep 2
    else
        estado=1
    fi
    return $estado
}

menuIniSesion() {
    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        
        echo "Ingrese su nombre de Usuario o Cédula (x) para volver"
        read -rp "-> " usuario
        verificarNoEspacio "$usuario"
        noEspacio=$?
        
        if [ $noEspacio -eq 1 ] 
        then
            if [ "$usuario" == "x" ] || [ "$usuario" == "X" ]
            then
                volver=1
            else
                echo "Ingrese su contraseña (x) para volver"
                read -rp "-> " contrasenia
                
                verificarNoEspacio "$contrasenia"
                noEspacio=$?
                
                if [ ! "$contrasenia" == "x" ] && [ ! "$contrasenia" == "X" ] && [ $noEspacio -eq 1 ]
                then
                    verificarLoggeo "$usuario" "$contrasenia"
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
        fi
    done
}

menuAdmin() {
    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        echo "Para registrar usuario opción 1."
        echo "Para registrar admin opción 2."
        echo "Para registrar mascota opción 3."
        echo "Para ver estadísticas de las adopciones opción 4."
        echo "Para cerrar sesión opción 0."
        read -rp "-> " opcion

        case $opcion in
        0)
            volver=1
        ;;
        1)
            menuRegistro "$opcion"
            volver=0
        ;;
        2)
            menuRegistro "$opcion"
            volver=0
        ;;
        3)
            menuRegistrarMascotas
            volver=0
        ;;
        4)
            menuEstadisticas
            volver=0
        ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            sleep 2
        ;;
        esac

    done
}

listarMascotas() {
    clear
    cat "./MascotasAdopcion.txt"
    volver=0
    while [ $volver -eq 0 ]
    do
        echo ""
        echo "(x) para salir"
        read -rp "-> " salirLstMasc
        if [ "$salirLstMasc" == "x" ] || [ "$salirLstMasc" == "X" ]
        then
            volver=1
        else
            clear
            cat "./MascotasAdopcion.txt"
        fi
    done
    return $volver
}

verifId() {
    
    estado=-1
    verificarNumPos $1
    valido=$?
    if grep -q "^"$id"" "./MascotasAdopcion.txt" && [ $valido -eq 1 ]
    then
        estado=1
    fi
    return $estado
}

adoptarMascota() {
    volver=0
    
    while [ $volver -eq 0 ]
    do
        clear
        echo "Escriba el id de la mascota. (x) para volver"
        read -rp "-> " id
        verifId "$id"
        idValido=$?

        if [ "$id" == "x" ] || [ "$id" == "X" ]
        then
            volver=1
        elif [ $idValido -eq 1 ]
        then
            id="$id-"   
            linea=$(grep "^"$id"" "./MascotasAdopcion.txt")
            if [ ! -z "$linea" ]  
            then
                fecha=$(date +"%d/%m/%Y")
                lineaAdoptado=$( echo "$linea" | awk -F'-' '{print $2"-"$3"-"$4"-"$5"-"$6"-"$7}' )
                sed -i "/^$id/d" "./MascotasAdopcion.txt"
                echo $lineaAdoptado >> "./adopciones.txt"
                echo "Adopcion Completada!!"
                sleep 2
            else
                echo "Mascota no encontrada"
                sleep 2
            fi
        fi
    done
}

menuUser() {
    volver=0

    while [ $volver -eq 0 ]
    do
        clear
        echo "Para listar mascotas en adopción opción 1."
        echo "Para adoptar mascota opción 2."
        echo "Para cerrar sesion opción 0."
        read -rp "-> " opcion

        case $opcion in
        0)
            volver=1
        ;;
        1)
            listarMascotas
            volver=0
        ;;
        2)
            adoptarMascota "$opcion"
            volver=0
        ;;
        3)
            $opcion
            volver=0
        ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            sleep 2
        ;;
        esac

    done
}

menuPrincipal() {
    salir=0

    while [ $salir -eq 0 ]
    do
        clear
        echo "Para iniciar sesion opción 1."
        echo "Para salir opción 0."
        read -rp "-> " opcion

        case $opcion in
        0)
            salir=1
        ;;
        1)
            menuIniSesion
        ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            sleep 2
        ;;
        esac
    done
    
}

verificarSisVacio() {
    if [ ! -f "./Admins.txt" ] 
    then
        touch "./Admins.txt"
        touch "./Users.txt"
        touch "./MascotasAdopcion.txt"
        touch "./adopciones.txt"

    fi
    if [ ! -s "./Admins.txt" ]
    then
        echo "admin:admin:" >> "./Admins.txt"
        echo ""
    fi
}

verificarSisVacio

menuPrincipal
clear
echo "chau mundo"
