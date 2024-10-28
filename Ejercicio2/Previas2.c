#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>

sem_t semIP, semED, semPA, semBD, semBigD, semSI, semCS, semDW;

void *IP(void *x) {
    printf("Introduccion a la Programacion\n");
    sem_post(&semED);
}
void *ED(void *x) {
    sem_wait(&semIP);
    printf("Estructura de Datos\n");
    sem_post(&semBD);
    sem_post(&semPA);
}
void *BD(void *x) {
    sem_wait(&semED);
    printf("Base de Datos\n");
    sem_post(semBigD);
    sem_post(semSI);
    sem_post(semDW);
}
void *PA(void *x) {
    sem_wait(&semED);
    printf("Programación Avanzada\n");
}
void *BigD(void *x) {
    sem_wait(&semBigD);
    printf("Big Data\n");
}
void *SI(void *x) {
    sem_wait(&semBD);
    printf("Seguridad Informatica\n");
    sem_post(&semCS);
}
void *CS(void *x) {
    sem_wait(&semSI);
    printf("Ciberseguridad\n");
}
void *DW(void *x) {
    sem_wait(&semBD);
    printf("Desarrollo Web\n");
}


int main() {

    pthread_t hiloIP , hiloED, hiloPA, hiloBD, hiloBigD, hiloSI, hiloCS, hiloDW;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    sem_init(&semIP);
    sem_init(&semED);
    sem_init(&semPA);
    sem_init(&semBD);
    sem_init(&semBigD);
    sem_init(&semSI);
    sem_init(&semCS);
    sem_init(&semDW);

    pthread_create(&hiloIP, &attr, IP, NULL);
    pthread_create(&hiloED, &attr, ED, NULL);
    pthread_create(&hiloPA, &attr, PA, NULL);
    pthread_create(&hiloBD, &attr, BD, NULL);
    pthread_create(&hiloBigD, &attr, BigD, NULL);
    pthread_create(&hiloSI, &attr, SI, NULL);
    pthread_create(&hiloCS, &attr, CS, NULL);
    pthread_create(&hiloDW, &attr, DW, NULL);

    pthread_join(hiloIP, NULL);
    pthread_join(hiloED, NULL);
    pthread_join(hiloPA, NULL);
    pthread_join(hiloBD, NULL);
    pthread_join(hiloBigD, NULL);
    pthread_join(hiloSI, NULL);
    pthread_join(hiloCS, NULL);
    pthread_join(hiloDW, NULL);
}