#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

void set_time(time_t seconds, suseconds_t microseconds);

void set_time(time_t seconds, suseconds_t microseconds)
{
	struct timeval tv;
	tv.tv_sec = seconds;
	tv.tv_usec = microseconds;
	settimeofday(&tv, NULL);
}

int main(int argc, char *argv[])
{
	int seconds, microseconds;
	sscanf(argv[1], "%d.%d", &seconds, &microseconds);
	set_time(seconds, microseconds);
	return 0;
}
