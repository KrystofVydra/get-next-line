CC = clang
CFLAGS = -Wall -Wextra -Werror
AR = ar
ARFLAGS = rc
RM = rm -f


SRC = 	get_next_line_utils.c get_next_line.c
OBJ = $(SRC:%.c=%.o)
LIB = get_next_line.a
NAME = get_next_line.a
HEADER = get_next_line.h

all: $(NAME)

$(NAME) : $(OBJ)
	$(AR) -rcs $(@) $(OBJ)

%.o: %.c
	$(CC) -Wall -Wextra -Werror -I$(HEADER) -c $< -o $@

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(LIB)

re: fclean all

.PHONY: all clean fclean re