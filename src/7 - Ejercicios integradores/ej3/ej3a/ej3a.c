#include "../ejs.h"

// Función auxiliar para contar casos por nivel
uint32_t contar_casos_por_nivel(caso_t* arreglo_casos, uint32_t largo, uint32_t nivel) {
    uint32_t res = 0;
    for (int i = 0; i < largo; i++){
        if ((arreglo_casos[i].usuario) -> nivel == nivel){
            res++;
        }
    }
    return res;
}


segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {

    uint32_t cant0 = contar_casos_por_nivel(arreglo_casos, largo, 0);
    uint32_t cant1 = contar_casos_por_nivel(arreglo_casos, largo, 1);
    uint32_t cant2 = contar_casos_por_nivel(arreglo_casos, largo, 2);



    caso_t* casos0;
    caso_t* casos1;
    caso_t* casos2;

    if (cant0 > 0){
        casos0 = malloc(cant0*sizeof(caso_t));
    } else {
        casos0 = NULL;
    }
    if (cant1 > 0){
        casos1 = malloc(cant1*sizeof(caso_t));
    } else {
        casos1 = NULL;
    }
    if (cant2 > 0){
        casos2 = malloc(cant2*sizeof(caso_t));
    } else {
        casos2 = NULL;
    }
    

    int indice0 = 0;
    int indice1 = 0;
    int indice2 = 0;

    for (int i = 0; i < largo; i++){
        uint32_t nivelCaso = (arreglo_casos[i].usuario) -> nivel;
        if (nivelCaso == 0){
            casos0[indice0] = arreglo_casos[i];
            indice0++;
        } else if (nivelCaso == 1){
            casos1[indice1] = arreglo_casos[i];
            indice1++;
        } else{
            casos2[indice2] = arreglo_casos[i];
            indice2++;
        }
    }

    segmentacion_t* res = malloc(24);
    res -> casos_nivel_0 = casos0;
    res -> casos_nivel_1 = casos1;
    res -> casos_nivel_2 = casos2;
    return res;
}



