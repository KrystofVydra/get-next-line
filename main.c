



#include "get_next_line.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>




int main (void){

	   int fd;
	   char buffer[10];
	   char *buff = &buffer[0];
	   char path[] = "file.txt";

	   fd = open(path, O_RDONLY);
	   //read(fd, buff, 1024);

	   char *output;

	   int i;
	   for (i = 0; i < 50; i++){
		   output = get_next_line(fd);
		   printf("[%s]", output);
	   }





	   //free(output);
	   return (0);
	   //printf("\n\n%s\n\n",buff);
	   }





/*

int main()
{
   int fd;
   char buff[1024];
   char path[] = "../../../Source/file.txt";

   fd = open(path, O_RDONLY);
   read(fd, buff, 1024);

   printf("\n\n%s\n\n",buff);
}
*/

