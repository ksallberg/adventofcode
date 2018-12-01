#include <stdio.h>
#include <string.h>

#define MAXCHAR 1000

int main() {
  FILE *fd;
  char str[MAXCHAR];
  char *filename = "input.txt";
  int val = 0;

  fd = fopen(filename, "r");
  if(fd == NULL) {
    printf("error opening: %s\n", filename);
  }

  while(fgets(str, MAXCHAR, fd) != NULL) {
    val += get_val(str);
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
