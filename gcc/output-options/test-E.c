#include <stdio.h>

int main(int argc, const char *argv[])
{
  printf("__FILE__: %s\n", __FILE__);
  printf("__LINE__: %d\n", __LINE__);
  printf("__DATE__: %s\n", __DATE__);
  printf("__TIME__: %s\n", __TIME__);
  printf("__STDC__: %d\n", __STDC__);
  printf("__STDC_VERSION__: %ld\n", __STDC_VERSION__);
  printf("__STDC_HOSTED__: %d\n", __STDC_HOSTED__);
  printf("__APPLE__: %d\n", __APPLE__);
  printf("__GNUC__: %d\n", __GNUC__);
  printf("__GNUC_MINOR__: %d\n", __GNUC_MINOR__);
  printf("__VERSION__: %s\n", __VERSION__);
#ifdef __OBJC__
  printf("__OBJC__: %d\n", __OBJC__);
#endif
#ifdef __ASSEMBLER__
  printf("__ASSEMBLER__: %d\n", __ASSEMBLER__);
#endif
#ifdef __cplusplus
  printf("__cplusplus: %ld\n", __cplusplus);
#endif
  return 0;
}
