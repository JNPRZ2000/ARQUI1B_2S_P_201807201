.global op_suma
.global op_resta
.global op_multiplicacion
.global op_division
.global op_potencia
.global op_factorial

.extern print_string
.extern read_integer


.section .data

msg_num1:
    .ascii "Ingrese el primer numero: "
msg_num1_len = . - msg_num1

msg_num2:
    .ascii "Ingrese el segundo numero: "
msg_num2_len = . - msg_num2

msg_base:
    .ascii "Ingrese la base: "
msg_base_len = . - msg_base

msg_exponente:
    .ascii "Ingrese el exponente: "
msg_exponente_len = . - msg_exponente

msg_factorial:
    .ascii "Ingrese el numero: "
msg_factorial_len = . - msg_factorial

error_division:
    .ascii "Error: no se puede dividir entre cero.\n"
error_division_len = . - error_division

error_exponente:
    .ascii "Error: el exponente debe ser no negativo.\n"
error_exponente_len = . - error_exponente

error_factorial:
    .ascii "Error: el factorial requiere un numero no negativo.\n"
error_factorial_len = . - error_factorial


.section .text


// SUMA

op_suma:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_num1
    mov x1, #msg_num1_len
    bl print_string

    bl read_integer
    mov x19, x0

    ldr x0, =msg_num2
    mov x1, #msg_num2_len
    bl print_string

    bl read_integer

    add x0, x19, x0

    ldp x29, x30, [sp], #16
    ret


// RESTA

op_resta:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_num1
    mov x1, #msg_num1_len
    bl print_string

    bl read_integer
    mov x19, x0

    ldr x0, =msg_num2
    mov x1, #msg_num2_len
    bl print_string

    bl read_integer

    sub x0, x19, x0

    ldp x29, x30, [sp], #16
    ret


// MULTIPLICACION

op_multiplicacion:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_num1
    mov x1, #msg_num1_len
    bl print_string

    bl read_integer
    mov x19, x0

    ldr x0, =msg_num2
    mov x1, #msg_num2_len
    bl print_string

    bl read_integer

    mul x0, x19, x0

    ldp x29, x30, [sp], #16
    ret


// DIVISION ENTERA

op_division:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_num1
    mov x1, #msg_num1_len
    bl print_string

    bl read_integer
    mov x19, x0

    ldr x0, =msg_num2
    mov x1, #msg_num2_len
    bl print_string

    bl read_integer

    // Divisor == 0
    cmp x0, #0
    b.eq division_error

    sdiv x0, x19, x0

    // Sin error
    mov x1, #0

    ldp x29, x30, [sp], #16
    ret


division_error:

    ldr x0, =error_division
    mov x1, #error_division_len
    bl print_string

    mov x0, #0
    mov x1, #1

    ldp x29, x30, [sp], #16
    ret


// POTENCIA
//
// Debe realizarse mediante multiplicacion
// repetida, según el enunciado.

op_potencia:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_base
    mov x1, #msg_base_len
    bl print_string

    bl read_integer
    mov x19, x0              // base

    ldr x0, =msg_exponente
    mov x1, #msg_exponente_len
    bl print_string

    bl read_integer
    mov x20, x0              // exponente

    // Exponente negativo
    cmp x20, #0
    b.lt potencia_error

    // resultado = 1
    mov x21, #1

    // contador = 0
    mov x22, #0


potencia_loop:

    cmp x22, x20
    b.ge potencia_fin

    mul x21, x21, x19

    add x22, x22, #1

    b potencia_loop


potencia_fin:

    mov x0, x21
    mov x1, #0

    ldp x29, x30, [sp], #16
    ret


potencia_error:

    ldr x0, =error_exponente
    mov x1, #error_exponente_len
    bl print_string

    mov x0, #0
    mov x1, #1

    ldp x29, x30, [sp], #16
    ret


// FACTORIAL
//
// Implementado mediante ciclo iterativo.

op_factorial:

    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =msg_factorial
    mov x1, #msg_factorial_len
    bl print_string

    bl read_integer
    mov x19, x0

    // Número negativo
    cmp x19, #0
    b.lt factorial_error

    // resultado = 1
    mov x20, #1

    // contador = 1
    mov x21, #1


factorial_loop:

    cmp x21, x19
    b.gt factorial_fin

    mul x20, x20, x21

    add x21, x21, #1

    b factorial_loop


factorial_fin:

    mov x0, x20
    mov x1, #0

    ldp x29, x30, [sp], #16
    ret


factorial_error:

    ldr x0, =error_factorial
    mov x1, #error_factorial_len
    bl print_string

    mov x0, #0
    mov x1, #1

    ldp x29, x30, [sp], #16
    ret