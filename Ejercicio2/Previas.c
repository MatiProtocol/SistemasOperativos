#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>

sem_t semIP, semM1, semF1, semED, semM2, semF2, semPA, semBD, semBigD, semRO, semRC, semSO, semIS, semSI, semIA, semCG, semDW, semSD, semCS, semAA;

void *IP(void * x) {
    sem_post(&semED);
    printf("Introducción a la Programacion\n");
}

void *M1(void * x) {
    sem_post(&semM2);
    printf("Matematica I\n");
}

void *F1(void * x) {
    printf("Física I\n");
    sem_post(&semF2);
}

void *ED(void * x) {
    sem_wait(&semIP);
    printf("Estructuras de Datos\n");
    sem_post(&semPA);
    sem_post(&semBD);
}   

void *M2(void * x) {
    sem_wait(&semM1);
    printf("Matemáticas II\n");
    sem_post(&semPA);
    sem_post(&semAA);
    sem_post(&semBigD);
    sem_post(&semIA);
}

void *F2(void * x) {
    sem_wait(&semF1);
    printf("Física II\n");
    sem_post(&semCG);
    sem_post(&semRC);
    sem_post(&semRO);
}

void *PA(void * x) {
    sem_wait(&semED);
    sem_wait(&semM2);
    printf("Programación Avanzada\n");
    sem_post(&semIS);
    sem_post(&semIA);
    sem_post(&semAA);
    sem_post(&semRO);
    sem_post(&semCG);
    sem_post(&semRC);
    sem_post(&semSO);
}

void *BD(void * x) {
    sem_wait(&semED);
    printf("Bases de Datos\n");
    sem_post(&semBigD);
    sem_post(&semSI);
    sem_post(&semDW);
}

void *RC(void * x) {
    sem_wait(&semF2);
    sem_wait(&semPA);
    printf("Redes de Computadoras\n");
    sem_post(&semSO);
    sem_post(&semSD);
    sem_post(&semDW);
}

void *SO(void * x) {
    sem_wait(&semPA);
    sem_wait(&semRC);
    printf("Sistemas Operativos\n");
    sem_post(&semSD);
    sem_post(&semCS);
}

void *IS(void * x) {
    sem_wait(&semPA);
    printf("Ingeniería de Software\n");
}

void *SI(void * x) {
    sem_wait(&semBD);
    printf("Seguridad Informática\n");
    sem_post(&semCS);
}

void *IA(void * x) {
    sem_wait(&semM2);
    sem_wait(&semPA);
    printf("Inteligencia Artificial\n");
}

void *CG(void * x) {
    sem_wait(&semPA);
    sem_wait(&semF2);
    printf("Computación Gráfica\n");
}

void *DW(void * x) {
    sem_wait(&semBD);
    sem_wait(&semRC);
    printf("Desarrollo Web\n");
}

void *SD(void * x) {
    sem_wait(&semSO);
    sem_wait(&semRC);
    printf("Sistemas Distribuidos\n");
}

void *BigD(void * x) {
    sem_wait(&semM2);
    sem_wait(&semBD);
    printf("Big Data\n");
}

void *RO(void * x) {
    sem_wait(&semF2);
    sem_wait(&semPA);
    printf("Robótica\n");
}

void *CS(void * x) {
    sem_wait(&semSO);
    sem_wait(&semSI);
    printf("Ciberseguridad\n");
}

void *AA(void * x) {
    sem_wait(&semPA);
    sem_wait(&semM2);
    printf("Análisis de Algoritmos\n");
}

int main() {

    sem_init(&semIP, 0, 1);
    sem_init(&semM1, 0, 1);
    sem_init(&semF1, 0, 1);
    sem_init(&semED, 0, 0);
    sem_init(&semM2, 0, 0);
    sem_init(&semF2, 0, 0);
    sem_init(&semPA, 0, 0);
    sem_init(&semBD, 0, 0);
    sem_init(&semBigD, 0, 0);
    sem_init(&semRO, 0, 0);
    sem_init(&semRC, 0, 0);
    sem_init(&semSO, 0, 0);
    sem_init(&semIS, 0, 0);
    sem_init(&semSI, 0, 0);
    sem_init(&semIA, 0, 0);
    sem_init(&semCG, 0, 0);
    sem_init(&semDW, 0, 0);
    sem_init(&semSD, 0, 0);
    sem_init(&semCS, 0, 0);
    sem_init(&semAA, 0, 0);

    pthread_t hiloIP, hiloM1, hiloF1, hiloED, hiloM2, hiloF2, hiloPA, hiloBD, hiloBigD, hiloRO, hiloRC, hiloSO, hiloIS, hiloSI, hiloIA, hiloCG, hiloDW, hiloSD, hiloCS, hiloAA;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

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

    sem_destroy(&semIP);
    sem_destroy(&semM1);
    sem_destroy(&semF1);
    sem_destroy(&semED);
    sem_destroy(&semM2);
    sem_destroy(&semF2);
    sem_destroy(&semPA);
    sem_destroy(&semBD);
    sem_destroy(&semBigD);
    sem_destroy(&semRO);
    sem_destroy(&semRC);
    sem_destroy(&semSO);
    sem_destroy(&semIS);
    sem_destroy(&semSI);
    sem_destroy(&semIA);
    sem_destroy(&semCG);
    sem_destroy(&semDW);
    sem_destroy(&semSD);
    sem_destroy(&semCS);
    sem_destroy(&semAA);

    return 0;

}
//gcc -pthread -o lab6 lab6.c