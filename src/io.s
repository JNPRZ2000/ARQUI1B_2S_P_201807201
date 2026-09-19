.global print_string
.global read_integer
.global print_integer



// DATOS NO INICIALIZADOS
.section .bss

.align 4

input_buffer:
    .skip 64

output_buffer:
    .skip 64

.section .text


/*
@ print_string
@
@ Imprime una cadena utilizando syscall write.
@
@ Entrada:
@   x0 = direccion de la cadena
@   x1 = longitud de la cadena
@ Syscall:
@   write(fd, buffer, count)
@   x0 = fd
@ x1 = buffer
@ x2 = count
@   x8 = 64
*/


print_string:

    mov x2, x1              // longitud
    mov x1, x0              // direccion de la cadena

    mov x0, #1              // stdout
    mov x8, #64             // syscall write

    svc #0

    ret



// read_integer
//
// Lee linea desde stdin y convierte a ASCII -> entero
//
// Acepta:
//   123
//   +123
//   -123
//   0
//
// Devuelve:
//   x0 = numero entero


read_integer:
    // Leer stdin

    mov x0, #0              // stdin
    ldr x1, =input_buffer
    mov x2, #64
    mov x8, #63             // syscall read

    svc #0

    // x0 contiene cantidad de bytes leidos
    mov x9, x0              // cantidad de bytes

    
    // Inicializar parser
    
    ldr x1, =input_buffer

    mov x2, #0              // resultado
    mov x3, #0              // indice
    mov x4, #0              // flag negativo

    // Si read() devolvio 0 o negativo
    cmp x9, #0
    b.le read_integer_return

    // Revisar primer caracter
    
    ldrb w5, [x1]

    // ASCII '-' = 45
    cmp w5, #45
    b.eq read_negative

    // ASCII '+' = 43
    cmp w5, #43
    b.eq read_positive

    // Si no tiene signo, empezar directamente
    b read_parse_loop


// Numero negativo

read_negative:

    mov x4, #1              // marcar negativo

    add x3, x3, #1          // saltar '-'

    b read_parse_loop

// Numero positivo con +

read_positive:

    add x3, x3, #1          // saltar '+'

    b read_parse_loop

// Conversion ASCII -> entero
//
// Formula:
// resultado = resultado * 10 + digito

read_parse_loop:
    // Evitar leer fuera de los bytes recibidos
    cmp x3, x9
    b.ge read_parse_end

    ldrb w5, [x1, x3]

    // '\n' ASCII 10
    cmp w5, #10
    b.eq read_parse_end

    // '\r' ASCII 13
    cmp w5, #13
    b.eq read_parse_end

    // Debe ser >= '0'
    cmp w5, #48
    b.lt read_parse_end

    // Debe ser <= '9'
    cmp w5, #57
    b.gt read_parse_end


    // resultado *= 10

    mov x6, #10

    mul x2, x2, x6


    // ASCII -> digito
    //
    // '0' = 48
    // '1' = 49
    // ...
    // '9' = 57

    sub w5, w5, #48

    uxtw x5, w5


    // resultado += digito

    add x2, x2, x5


    // siguiente caracter

    add x3, x3, #1

    b read_parse_loop

read_parse_end:

    // Revisar si era negativo

    cmp x4, #1
    b.ne read_integer_return

    // resultado = -resultado

    neg x2, x2


read_integer_return:

    mov x0, x2

    ret



// print_integer
//
// Convierte un entero con signo a ASCII y lo imprime.
//
// Entrada:
//   x0 = numero entero

print_integer:

    ldr x1, =output_buffer

    add x1, x1, #63


    
    // Colocar salto de linea

    mov w2, #10

    strb w2, [x1]

    mov x3, #1              // longitud actual


    
    // Copiar numero
    mov x4, x0


    
    // Caso especial: numero == 0
    cmp x4, #0
    b.ne print_check_negative

    sub x1, x1, #1

    mov w2, #48             // ASCII '0'

    strb w2, [x1]

    add x3, x3, #1

    b print_number

print_check_negative:

    mov x5, #0              // flag negativo

    cmp x4, #0

    b.ge print_conversion_loop


    // Era negativo

    mov x5, #1

    // Convertir a magnitud positiva

    neg x4, x4

// Conversion entero -> ASCII
print_conversion_loop:

    cmp x4, #0

    b.eq print_conversion_end

    // Divisor = 10
    mov x6, #10

    // cociente = numero / 10
    udiv x7, x4, x6


    // residuo = numero - (cociente * 10)
    //
    // msub:
    //
    // x8 = x4 - (x7 * x6)

    msub x8, x7, x6, x4


    // digito -> ASCII
    add x8, x8, #48

    // Retroceder una posicion
    sub x1, x1, #1

    // Guardar caracter
    strb w8, [x1]

    // Incrementar longitud
    add x3, x3, #1

    // numero = cociente
    mov x4, x7

    b print_conversion_loop


print_conversion_end:
    cmp x5, #1

    b.ne print_number


    // Agregar '-'
    sub x1, x1, #1

    mov w2, #45             // ASCII '-'

    strb w2, [x1]

    add x3, x3, #1



// Imprimir numero convertido
print_number:

    // write(stdout, buffer, longitud)
    mov x0, #1              // stdout

    // x1 ya apunta al inicio del numero
    mov x2, x3              // longitud

    mov x8, #64             // syscall write

    svc #0

    ret