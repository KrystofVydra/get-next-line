/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_utils.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kvydra <kvydra@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/14 16:57:05 by kvydra            #+#    #+#             */
/*   Updated: 2024/01/01 16:18:20 by kvydra           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"
#include <stdlib.h>
#include <unistd.h>

void	*ft_memcpy(void *dest, const void *src, unsigned int n)
{
	unsigned char	*dest_ptr;
	unsigned char	*src_ptr;

	if (!dest && !src)
		return (0);
	dest_ptr = (unsigned char *)dest;
	src_ptr = (unsigned char *)src;
	while (n)
	{
		*dest_ptr = *src_ptr;
		dest_ptr++;
		src_ptr++;
		n--;
	}
	return (dest);
}

void	*custom_realloc(void *ptr, unsigned int newSize, unsigned int oldSize)
{
	void			*newptr;
	unsigned int	bytestocopy;

	if (newSize == 0)
	{
		free(ptr);
		return (NULL);
	}
	newptr = malloc(newSize);
	if (newptr == NULL)
		return (NULL);
	if (ptr == NULL)
		return (newptr);
	if (oldSize < newSize)
		bytestocopy = oldSize;
	else
		bytestocopy = newSize;
	ft_memcpy(newptr, ptr, bytestocopy);
	free(ptr);
	return (newptr);
}

char	*main_reading(int readrtval, int index, unsigned int *total_size,
		int fd)
{
	char		*output;
	static char	g_buffer[BUFFER_SIZE];

	output = NULL;
	while (1)
	{
		//musis cist buffer size kterou zada uzivatel, takhle si porad cetl buffer size 1, buffer size se musi menit!
		readrtval = read(fd, &g_buffer[index], BUFFER_SIZE);
		if (readrtval <= 0)
		{
			if ((*total_size) == 0)
				return (NULL);
			break ;
		}
		(*total_size)++;
		output = custom_realloc(output, (*total_size) + 1, (*total_size));
		if (!output)
			return (NULL);
		output[(*total_size) - 1] = g_buffer[index];
		index++;
		if (g_buffer[index - 1] == '\n')
			break ;
	}
	return (output);
}
