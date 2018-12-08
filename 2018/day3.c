#include <stdio.h>
#include <string.h>

#define MAXCHAR 1000

void parse(char *str, int fabric[1000][1000], int phase2) {
  char *old;
  char temp[10];
  int id, posx, posy, width, height;
  int i,j=0;
  int unique=1;
  memset(temp, 0, sizeof temp);

  // remove #
  str++;
  old=str;
  while (*str!=' ') {
    str ++;
  }
  strncpy(temp, old, str-old);
  id = atoi(temp);
  memset(temp, 0, sizeof temp);

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
  if(phase2==0) {
    upg1(width, height, posx, posy, fabric);
  } else {
    // nu har vi fabric ifylld, se vilken som är unik
    unique = 1;
    for(i=0; i < height; i++) {
      for(j=0; j < width; j++) {
        if (fabric[(i+posy)][(j+posx)] != 1) {
          unique = 0;
        }
      }
    }
    if(unique==1) {
      printf("Den unika: %d\n", id);
    }
  }
}

void upg1(int width,
          int height,
          int posx,
          int posy,
          int fabric[1000][1000]) {
  int i, j = 0;
  for(i=0; i < height; i++) {
    for(j=0; j < width; j++) {
      fabric[(i+posy)][(j+posx)] ++;
    }
  }
}

int main() {
  FILE *fd;
  char str[MAXCHAR];

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
    parse(str, fabric, 0);
  }
  fclose(fd);

  for(i=0; i < 1000; i++) {
    for(j=0; j < 1000; j++) {
      if(fabric[i][j] >= 2) {
        claims++;
      }
    }
  }

  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  while(fgets(str, MAXCHAR, fd) != NULL) {
    parse(str, fabric, 1);
  }

  printf("Claimed squares: %d\n", claims);

  fclose(fd);

  return 0;
}
