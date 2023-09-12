/**
 * 
 * $HeadURL$
 * $Id$
 * $Revision$ 
 *
 * @file   get_next_line.c
 * @date   12. 9. 2023
 * @author vydra002
 * 
 * Copyright(c) 2023 Leopold Kostal GmbH & Co. KG. Content and presentation
 * are protected worldwide. Copying, issuing to other parties or any kind of use,
 * in whole or in part, is prohibited without prior permission. All rights -
 * including industrial property rights - are reserved.
 *
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "get_next_line.h"


static char buffer[BUFFER_SIZE];

char *get_next_line(int fd){
	char *output;
	unsigned int size = 0;
	unsigned int index = 0;
	unsigned int errorState = 0;


/*	while (size < BUFFER_SIZE){
		if (!read(fd, &buffer[index], 1) || !(buffer[index]))
			break;
		if (buffer[index] == '\n')
		{
			size++;
			break;
		}
		size++;
		index++;
	}*/

	readBuffer(&size, &index, fd, &buffer[0])

	output = (char*)malloc((size + 1) * sizeof(char));
	if (!output || size == 0){
		errorState = 1;
	}


	index = 0;
	if (!errorState)
	{
		while (index < size){
			*(output + index) = buffer[index];
			index++;
		}
		*(output + index) = '\0';
	}

	if (errorState)
		output = NULL;

	return (output);
}




int readBuffer(unsigned int *size, unsigned int *index, int fd, char **buffer)
{
	while (*size < BUFFER_SIZE){
		if (!read(fd, buffer[*index], 1) || !(buffer[*index]))
			break;
		if (*buffer[*index] == '\n')
		{
			*size++;
			break;
		}
		*size++;
		*index++;
	}
}

