#Tarea 2: Código ASCII
#Daniel De La O Rojas
#B82528

.data
    mensaje_cadena: .asciiz 		"\nIngrese una cadena: "
    mensaje_palabras: .asciiz 		"\nCantidad de palabras: "
    mensaje_caracteres: .asciiz 	"\nCantidad de caracteres (letras): "
    mensaje_vocales: .asciiz 		"\nCantidad de vocales: "
    mensaje_consonantes: .asciiz 	"\nCantidad de consonantes: "
    mensaje_mayusculas: .asciiz 	"\nCantidad de mayúsculas: "
    mensaje_minusculas: .asciiz 	"\nCantidad de minúsculas: "
    mensaje_puntuacion: .asciiz 	"\nCantidad de puntuación: "
    cadena: .space 100           # Espacio para una cadena de hasta 100 caracteres
    fin: .asciiz 			"\nFIN DEL PROGRAMA"

.text
main:
 
    # Pedir al usuario que ingrese una cadena
    
    la $a0, mensaje_cadena
    li $v0, 4
    syscall

    # Leer la cadena del usuario
    
    la $a0, cadena
    li $a1, 100            
    li $v0, 8
    syscall

    # Llamar a cada función y almacenar resultados
    
    la $a0, cadena
    jal contar_palabras
    move $t4, $v0           

    la $a0, cadena
    jal contar_caracteres
    move $t5, $v0          

    la $a0, cadena
    jal contar_vocales
    move $t6, $v0           

    la $a0, cadena
    jal contar_consonantes
    move $t7, $v0           

    la $a0, cadena
    jal contar_mayusculas    
    move $t8, $v0            

    la $a0, cadena
    jal contar_minusculas   
    move $t9, $v0            

    la $a0, cadena
    jal contar_puntuacion     
    move $s0, $v0             

    # Mostrar resultados
    
    la $a0, mensaje_palabras
    li $v0, 4
    syscall
    move $a0, $t4
    li $v0, 1
    syscall

    la $a0, mensaje_caracteres
    li $v0, 4
    syscall
    move $a0, $t5
    li $v0, 1
    syscall

    la $a0, mensaje_vocales
    li $v0, 4
    syscall
    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, mensaje_consonantes
    li $v0, 4
    syscall
    move $a0, $t7
    li $v0, 1
    syscall

    la $a0, mensaje_mayusculas
    li $v0, 4
    syscall
    move $a0, $t8
    li $v0, 1
    syscall

    la $a0, mensaje_minusculas
    li $v0, 4
    syscall
    move $a0, $t9
    li $v0, 1
    syscall

    la $a0, mensaje_puntuacion
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall

    # Fin del programa
    
    la $a0, fin
    li $v0, 4
    syscall

    li $v0, 10              
    syscall
    
     # Salir del programa

# Función contar_palabras

contar_palabras:
    li $t0, 0                 # Contador de palabras
    li $t1, 1                

loop_palabras:
    lb $t2, 0($a0)            # Cargar el caracter actual
    beqz $t2, fin_palabras   

    li $t3, ' '              
    beq $t2, $t3, es_espacio  # Si es espacio, ir a es_espacio

    beq $t1, 1, incrementar_palabra
    j no_incrementar          # No se incrementa el contador

es_espacio:
    li $t1, 1                 # Aquí lo lleva el es_espacio
    j no_incrementar

incrementar_palabra:
    addi $t0, $t0, 1          # Incrementar contador de palabras
    li $t1, 0                 # Cambiamos a estado de palabra

no_incrementar:
    addi $a0, $a0, 1          # Avanzar al siguiente caracter
    j loop_palabras           # Repetir el loop

fin_palabras:
    # Si el último caracter no es espacio, contamos la última palabra
    beq $t1, 0, sin_ultima_palabra
    addi $t0, $t0, 1
sin_ultima_palabra:
    move $v0, $t0             # Devolver el número de palabras contadas
    jr $ra                    # Volver



# Función contar_caracteres

contar_caracteres:
    li $t0, 0                # Inicializar contador

loop_caracteres:
    lb $t1, 0($a0)           
    beqz $t1, fin_caracteres # Si es vacío, sale


    li $t2, ' '              
    beq $t1, $t2, no_contar   # Si es un espacio no vale

    # Aquí se cuenta el caracter si es letra o puntuación
    j letra_o_puntuacion

letra_o_puntuacion:
    # Verificar si es minúscula o mayúscula
    li $t2, 'a'
    bge $t1, $t2, revisa_mayus
    li $t2, 'A'
    blt $t1, $t2, no_contar
    li $t2, 'Z'
    bgt $t1, $t2, no_contar
    j contar                # Si es mayúscula, contar

revisa_mayus:
    li $t2, 'z'
    bgt $t1, $t2, revisa_punt

    # Es letra minúscula, contar
    j contar

revisa_punt:
    # Comprobar si es un signo de puntuación
    li $t2, '.'
    beq $t1, $t2, contar
    li $t2, ','
    beq $t1, $t2, contar
    li $t2, ';'
    beq $t1, $t2, contar
    li $t2, ':'
    beq $t1, $t2, contar
    li $t2, '!'
    beq $t1, $t2, contar
    li $t2, '?'
    beq $t1, $t2, contar

    j no_contar

contar:
    addi $t0, $t0, 1          # Incrementar el contador
    
no_contar:
    addi $a0, $a0, 1          # Avanza al siguiente caracter
    j loop_caracteres         # Repetir el loop

fin_caracteres:
    move $v0, $t0             # Devuelve el número de caracteres contados
    jr $ra                    # Volver


# Función contar_vocales

contar_vocales:
    li $t0, 0                # Inicializar contador

loop_vocales:
    lb $t1, 0($a0)
    beqz $t1, fin_vocales

    # Comparar con vocales en minúsculas y mayúsculas
    li $t2, 'a'
    beq $t1, $t2, es_vocal
    li $t2, 'e'
    beq $t1, $t2, es_vocal
    li $t2, 'i'
    beq $t1, $t2, es_vocal
    li $t2, 'o'
    beq $t1, $t2, es_vocal
    li $t2, 'u'
    beq $t1, $t2, es_vocal
    li $t2, 'A'
    beq $t1, $t2, es_vocal
    li $t2, 'E'
    beq $t1, $t2, es_vocal
    li $t2, 'I'
    beq $t1, $t2, es_vocal
    li $t2, 'O'
    beq $t1, $t2, es_vocal
    li $t2, 'U'
    beq $t1, $t2, es_vocal

    j no_vocal

es_vocal:
    addi $t0, $t0, 1          # Incrementa contador de vocales

no_vocal:
    addi $a0, $a0, 1          # Avanza al siguiente caracter
    j loop_vocales

fin_vocales:
    move $v0, $t0             # Devuelve el número de vocales
    jr $ra

# Función contar_consonantes
contar_consonantes:
    li $t0, 0                 # Inicializar contador

loop_consonantes:
    lb $t1, 0($a0)            # Cargar el caracter actual
    beqz $t1, fin_consonantes # Si es vacío sale

    # Comprobar si es letra
    li $t2, 'A'               # Rango de letras mayúsculas
    blt $t1, $t2, no_consonante
    li $t2, 'Z'
    bgt $t1, $t2, revisa_minus

    # Si es letra mayúscula, verificar no sea vocal
    j revisa_vocal

revisa_minus:
    li $t2, 'a'               # Rango de letras minúsculas
    blt $t1, $t2, no_consonante
    li $t2, 'z'
    bgt $t1, $t2, no_consonante

    # Si es letra minúscula, verificar que no sea vocal
    j revisa_vocal

revisa_vocal:
    # Comparar con vocales en minúsculas y mayúsculas
    li $t2, 'a'
    beq $t1, $t2, no_consonante
    li $t2, 'e'
    beq $t1, $t2, no_consonante
    li $t2, 'i'
    beq $t1, $t2, no_consonante
    li $t2, 'o'
    beq $t1, $t2, no_consonante
    li $t2, 'u'
    beq $t1, $t2, no_consonante
    li $t2, 'A'
    beq $t1, $t2, no_consonante
    li $t2, 'E'
    beq $t1, $t2, no_consonante
    li $t2, 'I'
    beq $t1, $t2, no_consonante
    li $t2, 'O'
    beq $t1, $t2, no_consonante
    li $t2, 'U'
    beq $t1, $t2, no_consonante

    addi $t0, $t0, 1          # Incrementa contador de consonantes

no_consonante:
    addi $a0, $a0, 1          # Avanza al siguiente caracter
    j loop_consonantes

fin_consonantes:
    move $v0, $t0             # Devuelve el número de consonantes
    jr $ra


# Función contar_mayusculas

contar_mayusculas:
    li $t0, 0                # Inicializa contador

loop_mayusculas:
    lb $t1, 0($a0)
    beqz $t1, fin_mayusculas

    # Comprobar si es mayúscula
    li $t2, 'A'
    blt $t1, $t2, no_mayuscula
    li $t2, 'Z'
    bgt $t1, $t2, no_mayuscula
    addi $t0, $t0, 1          # Incrementa contador de mayúsculas

no_mayuscula:
    addi $a0, $a0, 1          # Avanza al siguiente caracter
    j loop_mayusculas

fin_mayusculas:
    move $v0, $t0             # Devuelve el número de mayúsculas
    jr $ra

# Función contar_minusculas

contar_minusculas:
    li $t0, 0                # Inicializa contador

loop_minusculas:
    lb $t1, 0($a0)
    beqz $t1, fin_minusculas

    # Comprobar si es minúscula
    li $t2, 'a'
    blt $t1, $t2, no_minuscula
    li $t2, 'z'
    bgt $t1, $t2, no_minuscula
    addi $t0, $t0, 1          # Incrementaa contador de minúsculas

no_minuscula:
    addi $a0, $a0, 1          # Avanzaa al siguiente caracter
    j loop_minusculas

fin_minusculas:
    move $v0, $t0             # Devuelve el número de minúsculas
    jr $ra

# Función contar_puntuacion

contar_puntuacion:
    li $t0, 0                # Inicializa contador

loop_puntuacion:
    lb $t1, 0($a0)
    beqz $t1, fin_puntuacion

    # Comparar con caracteres de puntuación especificados en la tarea
    li $t2, '.'
    beq $t1, $t2, es_puntuacion
    li $t2, ','
    beq $t1, $t2, es_puntuacion
    li $t2, ';'
    beq $t1, $t2, es_puntuacion
    li $t2, ':'
    beq $t1, $t2, es_puntuacion
    li $t2, '!'
    beq $t1, $t2, es_puntuacion
    li $t2, '?'
    beq $t1, $t2, es_puntuacion

    j no_puntuacion

es_puntuacion:
    addi $t0, $t0, 1          # Incrementa contador de puntuación

no_puntuacion:
    addi $a0, $a0, 1          # Avanza al siguiente caracter
    j loop_puntuacion

fin_puntuacion:
    move $v0, $t0             # Devuelve el número de puntuaciones
    jr $ra
