#include <stdio.h>
#include <string.h>
#include "list.h"

#define ROWS 1025
#define MAXCHAR 1000

int main() {
  FILE *fd;
  char str[ROWS][MAXCHAR];
  List *lseen;

  char *filename = "input.txt";
  int val = 0;
  int i, j = 0;

  lseen = l_create();

  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  i = 0;

  // save all lines to array
  while(fgets(str[i], MAXCHAR, fd) != NULL) {
    i ++;
  }

  i = 0;

  while(1) {
    val += get_val(str[i]);
    /* printf("val: %d\n", val); */

    if(did_see(lseen->head, val) == 1) {
      break;
    }
    l_add(lseen, val);

    i++;
    if(i == ROWS) {
      i = 0;
    }
  }

  printf("Final value: %d\n", val);

  fclose(fd);

  while(lseen->size > 0) {
    l_remove(lseen);
  }
  free(lseen);
  return 0;
}

int did_see(struct l_element *ls, int val) {
  if(ls == NULL) {
    return 0;
  }
  while(ls->next != NULL) {
    if(ls->value == val) {
      return 1;
    }
    ls = ls->next;
  }
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
