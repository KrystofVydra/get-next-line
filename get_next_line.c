/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kvydra <kvydra@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/14 16:55:27 by kvydra            #+#    #+#             */
/*   Updated: 2023/12/28 10:25:39 by kvydra           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"
#include <stdlib.h>
#include <unistd.h>

/* char	g_buffer[BUFFER_SIZE]; //change to static!!!*/

char	*get_next_line(int fd)
{
	char			*output;
	unsigned int	total_size;
	unsigned int	index;
	int				readrtval;

	//error checks !
	if (BUFFER_SIZE <= 0 || fd < 0 || fd > 1024)
		return (NULL);
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
