
## CONSIDERACIONES Y EXPLICACIONES DEL EJERCICIO 3

### GENERAL

De forma explicativa, si bien se solicita que la CPU tenga 9 operaciones, siendo que el pedido del ejercicio es hacer dos sumas en una misma variable, consideramos que solo las operaciones de los semáforos y las operaciones de LOAD, STORE y ADD son las necesarias, siendo no utilizadas en nuestra implementación las operaciones SUB y BRCPU. Por otro lado, la inclusión de las operaciones SEMINIT, SEMWAIT y SEMSIGNAL en las CPU no tiene sentido, ya que es redundante, cada semáforo por separado tiene sus propios métodos.

Entendemos que de toda la letra, lo que debe sudceder es que por consola se muestre el resultado de sumar 8 + 13 + 27 = 48, suendo 8 el valor de una variable, 13 la cantidad que suma un cpu y 27 la cantidad que suma el otro procesador.

El valor inicial en la memoria de la variable valor es en la posocion Valor_Pos = 100, en esa posicion se asigna 8. Luego se lee esta posición, se suma el valor del primer cpu y luego se guarda este nuevo valor en memoria. Una vez un cpu termina, el otro realiza los mismos pasos sumando su cantidad y guardando el resultado.
Para mostrarlo por consola, asignamos que una variable lea del lugar de memoria que se almaceno el resultado final para finalmente mostrar su valor por consola.

Se agrega al zip de resultado un archivo de texto llamado "main.txt" por si acaso falla el abrir el proyecto en GNAT abriendo el archivo default.gpr. De este modo se puede ver el código realizado sin tener que adentrarse a las carpetas internas del proyecto de GNAT. 

### DECLARACIÓN DE AUTORÍA

El ejercicio se llevó a cabo contando con la letra del mismo, la guía subida en el teams del grupo, el template del ejercicio también subido al teams del grupo y con la herramienta de Inteligencia Artificial Generativa.   
