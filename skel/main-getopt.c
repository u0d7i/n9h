#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char *myname;

void usage(void){
  fprintf(stderr, "usage: %s [options] <arg>\n", myname);
  fprintf(stderr, " -a            flag\n");
  fprintf(stderr, " -c <string>   string value\n");
  fprintf(stderr, " -h            this help\n");
  fprintf(stderr, " -i <int>      integer value\n");
  fprintf(stderr, " -v            be verbose\n");
  fprintf(stderr, " <arg>         mandatory argument\n");

  exit(1);
}

int main(int argc, char *argv[]){
  int c;
  int a_opt = 0;
  int i_opt = 0;
  char *c_opt = NULL;
  int verbose = 0;

  // mimic basename
  if ((myname=strrchr(argv[0],'/'))){
    myname++;
  }else{
    myname=argv[0];
  }

  while ((c = getopt(argc, argv, "ac:hi:v")) != -1){
    switch (c){
      case 'a' :
        a_opt = 1;
        break;
      case 'c' :
        c_opt = optarg;
        break;
      case 'h' :
        usage();
        break;
      case 'i' :
        i_opt = atoi(optarg);
      case 'v' :
        verbose = 1;
        break;
      case '?':
      default :
        usage();
    }
  }
  argc -= optind;
  argv += optind;
  // argv and argc are heavily modified at this point
  // check for single mandatory arg
  if ( argc != 1){
    usage();
  }

  if (verbose){
    printf ("I am verbose (verbose = %d)\n",verbose);
    printf ("a_opt = %d, i_opt = %d, c_opt = %s\n", a_opt, i_opt, c_opt);
    printf ("argv: %s\n", argv[0]);

  }

  fprintf(stderr,"%s: not yet implemented\n", myname);
  return(0);
}

