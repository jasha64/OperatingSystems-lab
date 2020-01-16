#include "types.h"
#include "user.h"

long long
Work0(void)
{
	long long cache = 0;
	for (long long i = 0; i < 10000000; i++) cache += i*i;
	return cache;
}

void
Work(int n)
{
	int rutime_c, retime_c, sltime_c;
	int rutime[4] = {}, retime[4] = {}, sltime[4] = {};
	int pid, pr;

	for (int i = 0; i < 4*n; i++)
	{
		if ((pid = fork()) == 0) {printf(2, "%d\n", Work0()); exit();}
		else if (setpriority(pid, i % 4) == -1) printf(1, "set priority failed\n");
	}
	for (int i = 0; i < 4*n; i++)
	{
		pid = waitsch(&rutime_c, &retime_c, &sltime_c, &pr);
		rutime[pr] += rutime_c; retime[pr] += retime_c; sltime[pr] += sltime_c;
	}
	for (int i = 0; i < 4; i++)
	{
		rutime[i] /= n; retime[i] /= n; sltime[i] /= n;
		printf(2, "Priority %d: rutime = %d, retime = %d, sltime = %d, total = %d\n", i, rutime[i], retime[i], sltime[i], rutime[i]+retime[i]+sltime[i]);
	}
}

int
main(int argc, char *argv[])
{
	if (argc <= 1)
	{
		printf(2, "usage: pbstatistic num\n");
		exit();
	}

	int n = atoi(argv[1]);
	Work(n);

	exit();
}
