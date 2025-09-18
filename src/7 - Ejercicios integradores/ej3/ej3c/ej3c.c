#include "../ejs.h"

estadisticas_t* calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id){

    estadisticas_t* res = malloc(7);

    for (int i = 0; i < largo; i++){
        if (usuario_id == 0 || usuario_id == arreglo_casos[i].usuario -> id){
            char* categoria = arreglo_casos[i].categoria;
            uint16_t estado = arreglo_casos[i].estado;

            if (categoria == "CLT"){

            }
        }
    }
    
}

