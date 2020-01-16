#include "types.h"
#include "user.h"

long long
Work0(void)
{
	long long cache = 0;
	for (long long i = 0; i < 10000000000ll; i++) cache += i*i;
	return cache;
}

void
Work(int n)
{
	int rutime_c, retime_c, sltime_c, pr;
	int rutime = 0, retime = 0, sltime = 0;
	for (int i = 0; i < n; i++)
		if (fork() == 0) {Work0(); exit();}
	for (int i = 0; i < n; i++)
	{
		waitsch(&rutime_c, &retime_c, &sltime_c, &pr);
		rutime += rutime_c; retime += retime_c; sltime += sltime_c;
	}
	rutime /= n; retime /= n; sltime /= n;
	printf(2, "rutime = %d, retime = %d, sltime = %d, total = %d\n", rutime, retime, sltime, rutime+retime+sltime);
}

int
main(int argc, char *argv[])
{
	if (argc <= 1)
	{
		printf(2, "usage: rrstatistic num\n");
		exit();
	}

	int n = atoi(argv[1]);
	Work(n);

	exit();
}
