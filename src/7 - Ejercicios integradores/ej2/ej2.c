#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {
    uint32_t hash = fun_hash(compartida);
    for (int i = 0; i < 255; i++){
        for (int j = 0; j < 255; j++){
            if (mapa[i][j] != NULL && mapa[i][j] != compartida){ // NO OLVIDARME DE CHEQUEAR NULL
                
                if (fun_hash(mapa[i][j]) == hash){
                    mapa[i][j] -> references -= 1;
                    if (mapa[i][j] -> references == 0){
                    free(mapa[i][j]);   
                    }

                    mapa[i][j] = compartida;
                    compartida -> references += 1;

                }
            }
        }
    }
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
    uint32_t res = 0;
    for (int i = 0; i < 255; i++){
        for (int j = 0; j < 255; j++){
            if (mapa[i][j] != NULL){ // NO OLVIDARME DE CHEQUEAR NULL
                uint16_t combustibleBase = fun_combustible(mapa[i][j] -> clase);
                res += (mapa[i][j] -> combustible) - combustibleBase;
            }
        }
    }
    return res;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {
	// COMPLETAR
	// Aclaraciones hechas durante el parcial: 
	// - Se puede usar la función strcpy de string.h
	// - Se puede asumir que el char clase[11] termina en 0
	if (mapa[x][y] != 0) {
        if(mapa[x][y]->references > 1) {

            //Hago la copia (nueva instancia)
            mapa[x][y]->references -= 1;
            attackunit_t* nuevaUnidad = malloc(sizeof(attackunit_t));
            nuevaUnidad->combustible = mapa[x][y]->combustible;
            nuevaUnidad->references = 1;

            strncpy(nuevaUnidad->clase, mapa[x][y]->clase, 11);
            
            // Actualizo el mapa
            mapa[x][y] = nuevaUnidad;

        }
        fun_modificar(mapa[x][y]);
    }

	return;
}
