#include <stdio.h>
#include <string.h>

#define ROWS 1025
#define MAXCHAR 1000
#define UGLY 200000
/* #define CHECK_BIT(var,pos) ((var) & (1<<(pos))) */

int main() {
  FILE *fd;
  char str[ROWS][MAXCHAR];
  int seen[UGLY];
  int seen_neg[UGLY];

  int seencnt = 0;
  char *filename = "input.txt";
  int val = 0;
  /* int seen = 0; */
  int has_seen = 0;
  int i, j = 0;

  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  for(i = 0; i < UGLY; i++) {
    seen[i] = 0;
    seen_neg[i] = 0;
  }

  i = 0;

  // save all lines to array
  while(fgets(str[i], MAXCHAR, fd) != NULL) {
    i ++;
  }

  i = 0;

  while(has_seen == 0) {
    val += get_val(str[i]);
    /* printf("val: %d\n", val); */

    /* if(CHECK_BIT(seen, val) == 1) { */
    /*   break; */
    /* } */
    /* seen |= 1 << val; */
    if(val >= 0) {
      if(seen[val] == 1) {
        has_seen=1;
        break;
      }
      seen[val] = 1;
    }
    else {
      if(seen_neg[val*(-1)] == 1) {
        has_seen=1;
        break;
      }
      seen_neg[val*(-1)] = 1;
    }


    /* seen[seencnt] = val; */
    /* seencnt++; */
    i++;
    if(i == ROWS) {
      i = 0;
    }
  }

  printf("Final value: %d\n", val);

  fclose(fd);
  return 0;
}

int get_val(char *str) {
  char *pointer = str;
  if(*pointer == 45) {
    pointer ++;
    return atoi(pointer) * -1;
  } else {
    pointer ++;
    return atoi(pointer);
  }
}
