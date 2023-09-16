

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

#include "get_next_line.h"


static char buffer[BUFFER_SIZE];


void *custom_realloc(void *ptr, unsigned int newSize, unsigned int oldSize) {
    newSize = newSize * sizeof(char);
	oldSize = oldSize * sizeof(char);
	
	if (newSize == 0) {
		free(ptr);
        return NULL;
    }

    if (ptr == NULL) {
        return malloc(newSize);
    }

    if (newSize <= oldSize) {
        return ptr;
    }

    void *newPtr = malloc(newSize);
    if (newPtr == NULL) {
        return NULL;
    }

    memcpy(newPtr, ptr, oldSize);

    free(ptr);

    return newPtr;
}

char *get_next_line(int fd){
	//char *output;
	char *output2 = NULL;
	unsigned int size = 0;
	unsigned int index = 0;
	unsigned int errorState = 0;
	int readRtVal = 0;
	unsigned int copy = 0;
	int done = 0;
	unsigned int oldSize = 0;

	while (done == 0 && errorState == 0)
	{
		while (size < BUFFER_SIZE && index < BUFFER_SIZE){
			readRtVal = read(fd, &buffer[index], 1);
			if (readRtVal == -1)
			{
				errorState = 1;
				done = 1;
				break;
			}
			if (readRtVal == 0 || buffer[index] == '\0')
			{
				if (oldSize == 0 && size == 0)
					errorState = 1;
				done = 1;
				break;
			}
			if (buffer[index] == '\n' || buffer[index] == '\0')
			{
				size++;
				done = 1;
				break;
			}
			size++;
			index++;
		}

		if (output2 == NULL)
			output2 = (char*)malloc(size * sizeof(char));
		else 
			output2 = (char*)custom_realloc(output2, oldSize + size, oldSize);

		index = 0;
		while (index < size)
		{
			*(output2 + copy) = buffer[index];
			copy++;
			index++;
		}
		
		oldSize = oldSize + size;
		size = 0;
		index = 0;
	}

	if (errorState)
	{
		free(output2);
		return (NULL);
	}


	// output = (char*)malloc((size + 1) * sizeof(char));
	// if (!output || size == 0){
	// 	errorState = 1;
	// } 
	// index = 0;
	// if (!errorState)
	// {
	// 	while (index < size){
	// 		*(output + index) = buffer[index];
	// 		index++;
	// 	}
	// 	//*(output + index) = '\0';
	// }



	// index = 0;
	// if (!errorState)
	// {
	// 	while (index < size){
	// 		*(output + index) = buffer[index];
	// 		index++;
	// 	}
	// 	*(output + index) = '\0';
	// }

	// if (errorState)
	// {
	// 	free(output);
	// 	output = NULL;
	// }

	return (output2);
}



