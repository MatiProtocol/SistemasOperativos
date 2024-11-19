#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>

sem_t semIP_ED, semM1_M2, semF1_F2, semED_BD, semED_PA, semM2_PA, semM2_IA, semM2_AA, semM2_BigD, semF2_RC, semF2_CG, semF2_RO, semPA_IA, semPA_RC, semPA_SO, semPA_IS, semPA_RO, semPA_CG, semPA_AA, semBD_SI, semBD_DW, semBD_BigD, semRC_SD, semRC_SO, semRC_DW, semRC_SI, semSO_SD, semSO_CS, semSI_CS;

void *IP(void * x) {
    printf("Introducción a la Programacion\n");
    sem_post(&semIP_ED);
}

void *M1(void * x) {
    printf("Matematica I\n");
    sem_post(&semM1_M2);
}

void *F1(void * x) {
    printf("Física I\n");
    sem_post(&semF1_F2);
}

void *ED(void * x) {
    sem_wait(&semIP_ED);
    printf("Estructuras de Datos\n");
    sem_post(&semED_PA);
    sem_post(&semED_BD);
}   

void *M2(void * x) {
    sem_wait(&semM1_M2);
    printf("Matemáticas II\n");
    sem_post(&semM2_PA);
    sem_post(&semM2_AA);
    sem_post(&semM2_BigD);
    sem_post(&semM2_IA);
}

void *F2(void * x) {
    sem_wait(&semF1_F2);
    printf("Física II\n");
    sem_post(&semF2_CG);
    sem_post(&semF2_RC);
    sem_post(&semF2_RO);
}

void *PA(void * x) {
    sem_wait(&semED_PA);
    sem_wait(&semM2_PA);
    printf("Programación Avanzada\n");
    sem_post(&semPA_IS);
    sem_post(&semPA_IA);
    sem_post(&semPA_AA);
    sem_post(&semPA_RO);
    sem_post(&semPA_CG);
    sem_post(&semPA_RC);
    sem_post(&semPA_SO);
}

void *BD(void * x) {
    sem_wait(&semED_BD);
    printf("Bases de Datos\n");
    sem_post(&semBD_BigD);
    sem_post(&semBD_SI);
    sem_post(&semBD_DW);
}

void *RC(void * x) {
    sem_wait(&semF2_RC);
    sem_wait(&semPA_RC);
    printf("Redes de Computadoras\n");
    sem_post(&semRC_SO);
    sem_post(&semRC_SD);
    sem_post(&semRC_DW);
}

void *SO(void * x) {
    sem_wait(&semPA_SO);
    sem_wait(&semRC_SO);
    printf("Sistemas Operativos\n");
    sem_post(&semSO_SD);
    sem_post(&semSO_CS);
}

void *IS(void * x) {
    sem_wait(&semPA_IS);
    printf("Ingeniería de Software\n");
}

void *SI(void * x) {
    sem_wait(&semBD_SI);
    printf("Seguridad Informática\n");
    sem_post(&semSI_CS);
}

void *IA(void * x) {
    sem_wait(&semM2_IA);
    sem_wait(&semPA_IA);
    printf("Inteligencia Artificial\n");
}

void *CG(void * x) {
    sem_wait(&semPA_CG);
    sem_wait(&semF2_CG);
    printf("Computación Gráfica\n");
}

void *DW(void * x) {
    sem_wait(&semBD_DW);
    sem_wait(&semRC_DW);
    printf("Desarrollo Web\n");
}

void *SD(void * x) {
    sem_wait(&semSO_SD);
    sem_wait(&semRC_SD);
    printf("Sistemas Distribuidos\n");
}

void *BigD(void * x) {
    sem_wait(&semM2_BigD);
    sem_wait(&semBD_BigD);
    printf("Big Data\n");
}

void *RO(void * x) {
    sem_wait(&semF2_RO);
    sem_wait(&semPA_RO);
    printf("Robótica\n");
}

void *CS(void * x) {
    sem_wait(&semSO_CS);
    sem_wait(&semSI_CS);
    printf("Ciberseguridad\n");
}

void *AA(void * x) {
    sem_wait(&semPA_AA);
    sem_wait(&semM2_AA);
    printf("Análisis de Algoritmos\n");
}

int main() {

    pthread_t hiloIP, hiloM1, hiloF1, hiloED, hiloM2, hiloF2, hiloPA, hiloBD, hiloBigD, hiloRO, hiloRC, hiloSO, hiloIS, hiloSI, hiloIA, hiloCG, hiloDW, hiloSD, hiloCS, hiloAA;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    sem_init(&semIP_ED, 0, 0);
    sem_init(&semM1_M2, 0, 0);
    sem_init(&semF1_F2, 0, 0);
    sem_init(&semED_BD, 0, 0);
    sem_init(&semED_PA, 0, 0);
    sem_init(&semM2_PA, 0, 0);
    sem_init(&semM2_IA, 0, 0);
    sem_init(&semM2_AA, 0, 0);
    sem_init(&semM2_BigD, 0, 0);
    sem_init(&semF2_RC, 0, 0);
    sem_init(&semF2_CG, 0, 0);
    sem_init(&semF2_RO, 0, 0);
    sem_init(&semPA_IA, 0, 0);
    sem_init(&semPA_RC, 0, 0);
    sem_init(&semPA_SO, 0, 0);
    sem_init(&semPA_IS, 0, 0);
    sem_init(&semPA_RO, 0, 0);
    sem_init(&semPA_CG, 0, 0);
    sem_init(&semPA_AA, 0, 0);
    sem_init(&semBD_SI, 0, 0);
    sem_init(&semBD_DW, 0, 0);
    sem_init(&semBD_BigD, 0, 0);
    sem_init(&semRC_SD, 0, 0);
    sem_init(&semRC_SO, 0, 0);
    sem_init(&semRC_DW, 0, 0);
    sem_init(&semSO_SD, 0, 0);
    sem_init(&semSO_CS, 0, 0);
    sem_init(&semSI_CS, 0, 0);


    pthread_create(&hiloIP, &attr, IP, NULL);
    pthread_create(&hiloM1, &attr, M1, NULL);
    pthread_create(&hiloF1, &attr, F1, NULL);
    pthread_create(&hiloED, &attr, ED, NULL);
    pthread_create(&hiloM2, &attr, M2, NULL);
    pthread_create(&hiloF2, &attr, F2, NULL);
    pthread_create(&hiloPA, &attr, PA, NULL);
    pthread_create(&hiloBD, &attr, BD, NULL);
    pthread_create(&hiloBigD, &attr, BigD, NULL);
    pthread_create(&hiloRO, &attr, RO, NULL);
    pthread_create(&hiloRC, &attr, RC, NULL);
    pthread_create(&hiloSO, &attr, SO, NULL);
    pthread_create(&hiloIS, &attr, IS, NULL);
    pthread_create(&hiloSI, &attr, SI, NULL);
    pthread_create(&hiloIA, &attr, IA, NULL);
    pthread_create(&hiloCG, &attr, CG, NULL);
    pthread_create(&hiloDW, &attr, DW, NULL);
    pthread_create(&hiloSD, &attr, SD, NULL);
    pthread_create(&hiloCS, &attr, CS, NULL);
    pthread_create(&hiloAA, &attr, AA, NULL);

    pthread_join(hiloIP, NULL);
    pthread_join(hiloM1, NULL);
    pthread_join(hiloF1, NULL);
    pthread_join(hiloED, NULL);
    pthread_join(hiloM2, NULL);
    pthread_join(hiloF2, NULL);
    pthread_join(hiloPA, NULL);
    pthread_join(hiloBD, NULL);
    pthread_join(hiloBigD, NULL);
    pthread_join(hiloRO, NULL);
    pthread_join(hiloRC, NULL);
    pthread_join(hiloSO, NULL);
    pthread_join(hiloIS, NULL);
    pthread_join(hiloSI, NULL);
    pthread_join(hiloIA, NULL);
    pthread_join(hiloCG, NULL);
    pthread_join(hiloDW, NULL);
    pthread_join(hiloSD, NULL);
    pthread_join(hiloCS, NULL);
    pthread_join(hiloAA, NULL);

    sem_destroy(&semIP_ED); 
    sem_destroy(&semM1_M2); 
    sem_destroy(&semF1_F2);
    sem_destroy(&semED_BD); 
    sem_destroy(&semED_PA); 
    sem_destroy(&semM2_PA); 
    sem_destroy(&semM2_IA); 
    sem_destroy(&semM2_AA); 
    sem_destroy(&semM2_BigD); 
    sem_destroy(&semF2_RC); 
    sem_destroy(&semF2_CG); 
    sem_destroy(&semF2_RO); 
    sem_destroy(&semPA_IA); 
    sem_destroy(&semPA_RC); 
    sem_destroy(&semPA_SO);
    sem_destroy(&semPA_IS);
    sem_destroy(&semPA_RO); 
    sem_destroy(&semPA_CG); 
    sem_destroy(&semPA_AA); 
    sem_destroy(&semBD_SI); 
    sem_destroy(&semBD_DW); 
    sem_destroy(&semBD_BigD); 
    sem_destroy(&semRC_SD); 
    sem_destroy(&semRC_SO); 
    sem_destroy(&semRC_DW); 
    sem_destroy(&semRC_SI);
    sem_destroy(&semSO_SD); 
    sem_destroy(&semSO_CS);
    sem_destroy(&semSI_CS);

    return 0;

}