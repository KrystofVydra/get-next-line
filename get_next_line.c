/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kvydra <kvydra@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/14 16:55:27 by kvydra            #+#    #+#             */
/*   Updated: 2023/12/27 13:58:43 by kvydra           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"
#include <stdlib.h>
#include <unistd.h>

char	g_buffer[BUFFER_SIZE]; //change to static!!!

char	*get_next_line(int fd)
{
	char			*output;
	unsigned int	total_size;
	unsigned int	index;
	int				readrtval;

	output = NULL;
	total_size = 0;
	index = 0;
	readrtval = 0;
	output = main_reading(readrtval, index, &total_size, fd);
	if (!output)
		return (NULL);
	output[total_size] = '\0';
	return (output);
}
