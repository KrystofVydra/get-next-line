/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_bonus.h                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kvydra <kvydra@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/14 16:56:03 by kvydra            #+#    #+#             */
/*   Updated: 2023/12/28 11:00:03 by kvydra           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_BONUS_H
# define GET_NEXT_LINE_BONUS_H

# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 1
# endif

// extern char	g_buffer[BUFFER_SIZE];

char		*get_next_line(int fd);

void		*ft_memcpy(void *dest, const void *src, unsigned int n);

void		*custom_realloc(void *ptr, unsigned int newSize,
				unsigned int oldSize);

char		*main_reading(int readrtval, int index, unsigned int *total_size,
				int fd);

#endif
