.global _start

.extern print_string
.extern read_integer
.extern print_integer
.extern op_suma
.extern op_resta
.extern op_multiplicacion
.extern op_division
.extern op_potencia
.extern op_factorial

.section .data

menu:
    .ascii "\n========== CALCULADORA ARM64 ==========\n"
    .ascii "1. Suma\n"
    .ascii "2. Resta\n"
    .ascii "3. Multiplicacion\n"
    .ascii "4. Division entera\n"
    .ascii "5. Potencia\n"
    .ascii "6. Factorial\n"
    .ascii "7. Salir\n"
    .ascii "Seleccione una opcion: "
menu_len = . - menu

msg_opcion_invalida:
    .ascii "Error: opcion invalida.\n"
msg_opcion_invalida_len = . - msg_opcion_invalida

msg_resultado:
    .ascii "Resultado: "
msg_resultado_len = . - msg_resultado

msg_despedida:
    .ascii "Saliendo de la calculadora...\n"
msg_despedida_len = . - msg_despedida


.section .text

_start:

menu_loop:

    // Mostrar menú
    ldr x0, =menu
    mov x1, #menu_len
    bl print_string

    // Leer opción
    bl read_integer

    // x0 contiene la opción
    cmp x0, #1
    b.eq opcion_suma

    cmp x0, #2
    b.eq opcion_resta

    cmp x0, #3
    b.eq opcion_multiplicacion

    cmp x0, #4
    b.eq opcion_division

    cmp x0, #5
    b.eq opcion_potencia

    cmp x0, #6
    b.eq opcion_factorial

    cmp x0, #7
    b.eq salir

    // Opción inválida
    ldr x0, =msg_opcion_invalida
    mov x1, #msg_opcion_invalida_len
    bl print_string

    b menu_loop


opcion_suma:
    bl op_suma
    b mostrar_resultado


opcion_resta:
    bl op_resta
    b mostrar_resultado


opcion_multiplicacion:
    bl op_multiplicacion
    b mostrar_resultado


opcion_division:
    bl op_division

    // x1 = 1 significa error
    cmp x1, #1
    b.eq menu_loop

    b mostrar_resultado


opcion_potencia:
    bl op_potencia

    cmp x1, #1
    b.eq menu_loop

    b mostrar_resultado


opcion_factorial:
    bl op_factorial

    cmp x1, #1
    b.eq menu_loop

    b mostrar_resultado


mostrar_resultado:

    // Guardamos resultado
    mov x19, x0

    ldr x0, =msg_resultado
    mov x1, #msg_resultado_len
    bl print_string

    mov x0, x19
    bl print_integer

    b menu_loop


salir:

    ldr x0, =msg_despedida
    mov x1, #msg_despedida_len
    bl print_string

    mov x0, #0
    mov x8, #93
    svc #0