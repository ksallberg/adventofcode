#include <stdio.h>
#include <string.h>
#include "list.h"

#define MAXCHAR 1000

void parse(char *str, char *temp) {
  char *old;
  int posx, posy;
  memset(temp, 0, sizeof temp);
  /* char *tempp = *temp; */
  while (*str!='@') {
    str ++;
  }
  str+=2;
  old=str;
  while (*str!=',') {
    str++;
  }
  strncpy(temp, old, str-old);
  posx = atoi(temp);

  str++;
  old=str;
  while(*str!=':') {
    str++;
  }
  strncpy(temp, old, str-old);
  posy = atoi(temp);

  str+=2;
  old=str;

  printf("posx: %d\n", posx);
  printf("posy: %d\n", posy);

  /* printf("temp %s\n", temp); */
  printf("%s\n", str);
}

int main() {
  FILE *fd;
  char str[MAXCHAR];
  char temp[10];

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
    parse(str, temp);
  }

  fclose(fd);

  return 0;
}
