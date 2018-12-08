#include <stdio.h>
#include <string.h>
#include "list.h"

#define MAXCHAR 1000

void parse(char *str, int fabric[1000][1000]) {
  char *old;
  char temp[10];
  int posx, posy, width, height;
  int i,j=0;
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
  memset(temp, 0, sizeof temp);

  str++;
  old=str;
  while(*str!=':') {
    str++;
  }
  strncpy(temp, old, str-old);
  posy = atoi(temp);
  memset(temp, 0, sizeof temp);

  str+=2;
  old=str;

  while(*str!='x') {
    str++;
  }

  strncpy(temp, old, str-old);
  width = atoi(temp);
  memset(temp, 0, sizeof temp);

  str++;
  old=str;

  while(*str!='\0') {
    str++;
  }

  strncpy(temp, old, str-old);
  height = atoi(temp);

  //fyll i själva arrayen
  /* printf("posx: %d\n", posx); */
  /* printf("posy: %d\n", posy); */
  /* printf("width: %d\n", width); */
  /* printf("height: %d\n", height); */
  for(i=0; i < height; i++) {
    for(j=0; j < width; j++) {
      fabric[(i+posy)][(j+posx)] ++;
    }
  }

  /* printf("temp %s\n", temp); */
  /* printf("%s\n", str); */
}

int main() {
  FILE *fd;
  char str[MAXCHAR];

  List *lseen;

  int fabric[1000][1000];
  int i, j, claims=0;

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
    parse(str, fabric);
  }

  for(i = 0; i < 1000; i++) {
    for(j = 0; j < 1000; j++) {
      if(fabric[i][j] >= 2) {
        claims ++;
      }
      /* printf("%d", fabric[i][j]); */
    }
    /* printf("\n"); */
  }

  printf("Claimed squares: %d\n", claims);

  fclose(fd);

  return 0;
}
