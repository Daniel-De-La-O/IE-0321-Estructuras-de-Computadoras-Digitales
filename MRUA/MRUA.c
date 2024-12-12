#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Función para obtener los valores de entrada
int obtener_valor(char *opcion, float *valor, const char *mensaje, int *count_x, int *count_n) {
    char input[100]; // Buffer para manejar entradas de texto

    printf("%s", mensaje);
    scanf(" %s", input);

    // Verificar si el usuario desea salir
    if (strcmp(input, "salir") == 0) {
        printf("Programa finalizado por el usuario.\n");
        exit(0); // Terminar el programa
    }

    // Verificar si la entrada es 'f', 'x', o 'n'
    if (strlen(input) == 1) { // Solo se aceptan caracteres individuales para estas opciones
        *opcion = input[0];

        if (*opcion == 'f') {
            printf("Valor: ");
            if (scanf("%f", valor) != 1) {
                if (scanf(input, "salir") == 0) {
                    printf("Programa finalizado por el usuario.\n");
                    exit(0); // Terminar el programa
                }
                printf("ADVERTENCIA: Debe ingresar un valor numérico válido.\n");
                while (getchar() != '\n'); // Limpiar el buffer
                return 0; // Entrada inválida
            }
        } else if (*opcion == 'x') {
            (*count_x)++;
            if (*count_x > 1) {
                printf("ERROR: Solo puede haber una 'x'. Inténtelo de nuevo.\n");
                return 0; // Entrada inválida
            }
        } else if (*opcion == 'n') {
            (*count_n)++;
            if (*count_n > 1) {
                printf("ERROR: Solo puede haber una 'n'. Inténtelo de nuevo.\n");
                return 0; // Entrada inválida
            }
        } else {
            printf("ERROR: Entrada inválida. Debe ingresar 'f', 'x', 'n' o 'salir'.\n");
            return 0; // Entrada inválida
        }
    } else {
        printf("ERROR: Entrada inválida. Debe ingresar 'f', 'x', 'n' o 'salir'.\n");
        return 0; // Entrada inválida
    }

    return 1;
}

int main() {
    float Vi, Vf, a, d, t;
    char opc_Vi, opc_Vf, opc_a, opc_d, opc_t;
    int count_x = 0, count_n = 0; // Contadores para validar las reglas

    printf("¡Bienvenido a la calculadora MRUA!\n");

    while (1) {
        count_x = 0; // Reinicia los contadores en cada ciclo
        count_n = 0;

        // Captura cada valor con validación inmediata
        if (!obtener_valor(&opc_Vi, &Vi, "Velocidad inicial (m/s): ", &count_x, &count_n)) continue;
        if (!obtener_valor(&opc_Vf, &Vf, "Velocidad final (m/s): ", &count_x, &count_n)) continue;
        if (!obtener_valor(&opc_a, &a, "Aceleración (m/s^2): ", &count_x, &count_n)) continue;
        if (!obtener_valor(&opc_d, &d, "Distancia (m): ", &count_x, &count_n)) continue;
        if (!obtener_valor(&opc_t, &t, "Tiempo (s): ", &count_x, &count_n)) continue;

        // Validar al final que las reglas se cumplan
        if (count_x != 1 || count_n != 1) {
            printf("ERROR: Debe haber exactamente una 'x' y una 'n'. Inténtelo de nuevo.\n");
            continue;
        }

        break; // Salir del ciclo si todo es válido
    }

    // Cálculos 
    if (opc_Vi == 'x') {
        if (opc_Vf == 'f' && opc_a == 'f' && opc_t == 'f' && opc_d == 'n') {
            Vi = Vf - a * t;
        } else if (opc_Vf == 'f' && opc_a == 'f' && opc_t == 'n' && opc_d == 'f') {
            Vi = sqrt(Vf * Vf - 2 * a * d);
        } else if (opc_Vf == 'f' && opc_a == 'n' && opc_t == 'f' && opc_d == 'f') {
            Vi = (2 * d) / t - Vf;
        } else if (opc_Vf == 'n' && opc_a == 'f' && opc_t == 'f' && opc_d == 'f') {
            Vi = (2 * d - a * t * t) / (2 * t);
        }
        printf("La velocidad inicial es: %.2f m/s\n", Vi);
    } 
    
    else if (opc_Vf == 'x') {
        if (opc_Vi == 'f' && opc_a == 'f' && opc_t == 'f' && opc_d == 'n') {
            Vf = Vi + a * t;
        } else if (opc_Vi == 'f' && opc_a == 'f' && opc_t == 'n' && opc_d == 'f') {
            Vf = sqrt(Vi * Vi + 2 * a * d); 
        } else if (opc_Vi == 'f' && opc_a == 'n' && opc_t == 'f' && opc_d == 'f') {
            Vf = (2 * d - Vi * t) / t;
        } else if (opc_Vi == 'n' && opc_a == 'f' && opc_t == 'f' && opc_d == 'f') {
            Vf = (2 * d + a * t * t) / (2 * t);
        }
        printf("La velocidad final es: %.2f m/s\n", Vf);
    } 
    
    else if (opc_a == 'x') {
        if (opc_Vf == 'f' && opc_Vi == 'f' && opc_t == 'f' && opc_d == 'n') {
            a = (Vf - Vi) / t;
        } else if (opc_Vf == 'f' && opc_Vi == 'f' && opc_t == 'n' && opc_d == 'f') {
            a = (Vf * Vf - Vi * Vi) / (2 * d); 
        } else if (opc_Vf == 'f' && opc_Vi == 'n' && opc_t == 'f' && opc_d == 'f') {
            a = (2 * Vf * t - 2 * d) / (t * t);
        } else if (opc_Vf == 'n' && opc_Vi == 'f' && opc_t == 'f' && opc_d == 'f') {
            a = (2 * d - 2 * Vi * t) / (t * t);
        }
        printf("La aceleración es: %.2f m/s^2\n", a);
    } 
    
    else if (opc_d == 'x') {
        if (opc_Vf == 'f' && opc_a == 'f' && opc_t == 'f' && opc_Vi == 'n') {
            d = fabs((2 * Vf * t - a * t * t) / 2); 
        } else if (opc_Vf == 'f' && opc_a == 'f' && opc_t == 'n' && opc_Vi == 'f') {
            d = fabs((Vf * Vf - Vi * Vi) / (2 * a));  
        } else if (opc_Vf == 'f' && opc_a == 'n' && opc_t == 'f' && opc_Vi == 'f') {
            d = fabs((t * (Vf + Vi)) / 2);  
        } else if (opc_Vf == 'n' && opc_a == 'f' && opc_t == 'f' && opc_Vi == 'f') {
            d = fabs(Vi * t + (a * t * t) / 2);  
        }
        printf("La distancia es: %.2f m\n", d);
    } 

    else if (opc_t == 'x') {
        if (opc_Vf == 'f' && opc_a == 'f' && opc_Vi == 'f' && opc_d == 'n') {
            t = fabs((Vf - Vi) / a);  
        } else if (opc_Vf == 'f' && opc_a == 'f' && opc_Vi == 'n' && opc_d == 'f') {
            t = fabs((Vf - sqrt(Vf * Vf - 2 * a * d)) / a);  
        } else if (opc_Vf == 'f' && opc_a == 'n' && opc_Vi == 'f' && opc_d == 'f') {
            t = fabs((2 * d) / (Vf + Vi));  
        } else if (opc_Vf == 'n' && opc_a == 'f' && opc_Vi == 'f' && opc_d == 'f') {
            t = fabs((-Vi + sqrt(Vi * Vi + 2 * a * d)) / a);  
        }
        printf("El tiempo es: %.2f s\n", t);
    } 
    
    return 0;
}

