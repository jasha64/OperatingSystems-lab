#include "types.h"
#include "user.h"

int main()
{
	printf(1, "*** Testing syscall getfpid() ***\n");
	if (fork() == 0) printf(1, "getfpid() returns value: %d\n", getfpid());
	else {wait(); printf(1, "Parent process pid is %d\n", getpid());}
	exit();
}
