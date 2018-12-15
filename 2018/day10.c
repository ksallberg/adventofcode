// Strategi: kolla pa max och min-varden och se nar dom borjar ga ihop
#include <stdio.h>
#include <string.h>

#define MAXCHAR 1000

struct star {
  int posx;
  int posy;
  int xvel;
  int yvel;
} typedef star;

void parse(char *str, star *curline) {
  char temp[10];
  char *old;

  /* int posx, posy, xvel, yvel; */
  memset(temp, 0, sizeof temp);
  str += 10;
  old = str;
  str += 6;
  strncpy(temp, old, str-old);
  curline->posx = atoi(temp);

  memset(temp, 0, sizeof temp);
  str += 2;
  old = str;
  str += 6;
  strncpy(temp, old, str-old);
  curline->posy = atoi(temp);

  memset(temp, 0, sizeof temp);
  str += 12;
  old = str;
  str += 2;
  strncpy(temp, old, str-old);
  curline->xvel = atoi(temp);

  memset(temp, 0, sizeof temp);
  str += 2;
  old = str;
  str += 2;
  strncpy(temp, old, str-old);
  curline->yvel = atoi(temp);
}

void step(star *curline) {
  /* printf("old: %d", curline->posx); */
  curline->posx = curline->posx + curline->xvel;
  /* printf("new: %d", curline->posx); */
  curline->posy = curline->posy + curline->yvel;
}

int is_match(int y, int x, star points[367]) {
  int i;
  for(i=0; i < 367; i++) {
    if(points[i].posx == x && points[i].posy == y) {
      return 1;
    }
  }
  return 0;
}

int main() {
  FILE *fd;
  char str[MAXCHAR];

  char *filename = "input.txt";
  star points[367];
  int i=0, j, k=0;
  int minDrawX = 100;
  int maxDrawX = 300;
  int minDrawY = 118;
  int maxDrawY = 130;

  int minx,maxx,miny,maxy=0;
  int counter=0;

  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  // save all lines to array
  while(fgets(str, MAXCHAR, fd) != NULL) {
    parse(str, &points[i]);
    i++;
  }

  while(1) {
    minx=0;
    maxx=0;
    miny=0;
    maxy=0;
    counter ++;

    for(i=0; i < 367; i++) {
      if(points[i].posx < minx && points[i].xvel != 0) {
        minx = points[i].posx;
      }
      if(points[i].posx > maxx && points[i].xvel != 0) {
        maxx = points[i].posx;
      }
      if(points[i].posy < miny && points[i].yvel != 0) {
        miny = points[i].posx;
      }
      if(points[i].posy > maxy && points[i].yvel != 0) {
        maxy = points[i].posx;
      }
      step(&points[i]);
    }

    // exit condition
    if(counter==10454) {
      break;
    }
  }
  for(i=minDrawY; i < maxDrawY; i++) {
    for(j=minDrawX; j < maxDrawX; j ++) {
      if(is_match(i, j, points) == 1) {
        printf("#");
      } else {
        printf(".");
      }
    }
    printf("\n");
  }
  printf("efter\n");

  fclose(fd);

  return 0;
}
