#include <stdio.h>
#include <stdlib.h>

int demodProcess(float * inRecData, float * quRecData, int startPoint);

int dqpskDemod(float * inRecData, float * quRecData)
{
	printf("DQPSK Demodulate Start\n");
	int ret = 1;
	int result;
	int setting[16] = {0};
	int num_setting = 0;

	/****Demod Process****/
	int startPoint;
	for(startPoint = 0;startPoint < 16;startPoint++)
	{
		result=demodProcess(inRecData, quRecData, startPoint);
		if(result == 0)
		{
			setting[num_setting] = startPoint;
			num_setting++;
		}
		
	}

	if(num_setting > 0)
	{
		ret = 0;
		int i;
		for(i = 0;i < num_setting;i++)
		{
			printf("Start Point: %d.\n", setting[i]);
		}
	}
	printf("DQPSK Demodulate End\n");

	return ret;
}