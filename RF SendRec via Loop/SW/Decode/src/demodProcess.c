#include <stdio.h>
#include <stdlib.h>

int projectInfoData[] = {0, 0, 0, 0, 1, 1, 1, 1,
                         0, 0, 0, 0, 1, 1, 1, 1,
                         0, 1, 1, 0, 0, 0, 1, 1,
                         1, 1, 0, 0, 0, 1, 0, 1};

int findData(int * infoBit);

int demodProcess(float * inRecData, float * quRecData, int startPoint)
{
	int ret = 1;
	float iD[2032] = {0}, qD[2032] = {0};
	int inBit[127] = {0}, quBit[127] = {0};

	//Doing multi operation, one bit period is 16 points, delay one bit period
	int i;
	for(i = 0;i < 2032;i++)
	{
		iD[i] = inRecData[i+startPoint] * inRecData[i+startPoint+16];
		qD[i] = quRecData[i+startPoint] * quRecData[i+startPoint+16];
	}

	//Then judge 0 or 1
	int j;
	for(i = 0;i < 127;i++)
	{
		float isum = 0, qsum = 0;
		for(j = 0;j < 16;j++)
		{
			isum = isum + iD[i*16+j];
			qsum = qsum + qD[i*16+j];
		}
		if(isum < 0) inBit[i] = 1;
		else inBit[i] = 0;
		if(qsum < 0) quBit[i] = 1;
		else quBit[i] = 0;
	}

	//Combine again
	int infoBit[254] = {0};
	for(i = 0;i < 127;i++)
	{
		infoBit[2*i] = inBit[i];
		infoBit[2*i+1] = quBit[i];
	}

	//Find Data
	ret = findData(infoBit);

	return ret;
}

int findData(int * infoBit)
{
	int matchPoints = 0;
	int ret = 1;
	int i,j;
	for(i = 0;i < 222;i++)
	{
		int same = 1;
		for(j = 0;j < 32;j++)
		{
			if(infoBit[i+j] != projectInfoData[j]) same = 0;
		}
		if(same == 1)
		{
			matchPoints++;
		}
	}

	if(matchPoints > 5) ret = 0;

	return ret;
}