#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <arm_neon.h>
#include <pthread.h>

// Number of threads to create
#define NUM_THREADS 4

typedef struct values
{
    int num;
    float *a;
    float *b;
    float *r;
} Values;

struct timespec ts_start;
struct timespec ts_end_1;
struct timespec ts_end_2;

void mult_std(float *a, float *b, float *r, int num)
{
    for (int i = 0; i < num; i++)
    {
        r[i] = a[i] * b[i];
    }
}

void mult_vect(float *a, float *b, float *r, int num)
{
    float32x4_t va, vb, vr;
    for (int i = 0; i < num; i += 4)
    {
        va = vld1q_f32(&a[i]);
        vb = vld1q_f32(&b[i]);
        vr = vmulq_f32(va, vb);
        vst1q_f32(&r[i], vr);
    }
}

// Thread function
void *calc(void *threadId)
{
    Values *values = (Values *)threadId;

    // mult_std(values->a, values->b, values->r, values->num);
    mult_vect(values->a, values->b, values->r, values->num);

    // pthread_exit(NULL);
    // return NULL; // This line is typically not reached due to pthread_exit above.
}

void creatThreads()
{
    Values values[NUM_THREADS];
    int num = 100000000;
    float *a = (float *)aligned_alloc(16, num * sizeof(float));
    float *b = (float *)aligned_alloc(16, num * sizeof(float));
    float *r = (float *)aligned_alloc(16, num * sizeof(float));
    for (int i = 0; i < num; i++)
    {
        a[i] = (i % 127) * 0.1457f;
        b[i] = (i % 331) * 0.1231f;
    }
    pthread_t threads[NUM_THREADS];
    int rc, size = num / NUM_THREADS;
    clock_gettime(CLOCK_MONOTONIC, &ts_start);
    for (long t = 0; t < NUM_THREADS; t++)
    {
        values[t].a = a + t * size;
        values[t].b = b + t * size;
        values[t].r = r + t * size;
        values[t].num = size;
        rc = pthread_create(&threads[t], NULL, calc, (void *)&values[t]);
        if (rc)
        {
            printf("Error: Unable to create thread, %d\n", rc);
            exit(-1);
        }
    }
    for (long t = 0; t < NUM_THREADS; t++)
    {
        pthread_join(threads[t], NULL);
    }

    clock_gettime(CLOCK_MONOTONIC, &ts_end_1);
    // clock_gettime(CLOCK_MONOTONIC, &ts_end_2);

    free(a);
    free(b);
    free(r);
}

int main(int argc, char *argv[])
{

    // pthread_t threads[NUM_THREADS] = creatThreadStruct();

    creatThreads();
    double duration_std = (ts_end_1.tv_sec - ts_start.tv_sec) +
                          (ts_end_1.tv_nsec - ts_start.tv_nsec) * 1e-9;
    // double duration_vec = (ts_end_2.tv_sec - ts_end_1.tv_sec) +
    //                       (ts_end_2.tv_nsec - ts_end_1.tv_nsec) * 1e-9;
    // printf("Elapsed time std: %f\n", duration_std);
    printf("Elapsed time vec: %f\n", duration_std);
    return 0;
}

// joel@joel-desktop:~/Lab1$ gcc multiply.c -o multiply -O0
// joel@joel-desktop:~/Lab1$ ./multiply
// Elapsed time std: 1.503611
// Elapsed time vec: 0.807917
// joel@joel-desktop:~/Lab1$ gcc multiply.c -o multiply -O1
// joel@joel-desktop:~/Lab1$ ./multiply
// Elapsed time std: 0.914365
// Elapsed time vec: 0.231164
// joel@joel-desktop:~/Lab1$ gcc multiply.c -o multiply -O2
// joel@joel-desktop:~/Lab1$ ./multiply
// Elapsed time std: 0.900447
// Elapsed time vec: 0.204703
// joel@joel-desktop:~/Lab1$ gcc multiply.c -o multiply -O3
// joel@joel-desktop:~/Lab1$ ./multiply
// Elapsed time std: 0.872838
// Elapsed time vec: 0.204316
