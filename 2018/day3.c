#include <stdio.h>
#include <string.h>
#include "list.h"

#define MAXCHAR 1000

int main() {
  FILE *fd;
  char str[MAXCHAR];
  List *lseen;

  int fabric[1000][1000];
  int i, j=0;

  char *filename = "input.txt";

  for(i = 0; i < 1000; i++) {
    for(j = 0; j < 1000; j++) {
      fabric[i][j] = 0;
    }
  }
  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  // save all lines to array
  while(fgets(str, MAXCHAR, fd) != NULL) {
    printf("chars: %s\n", str);
  }

  fclose(fd);

  return 0;
}
