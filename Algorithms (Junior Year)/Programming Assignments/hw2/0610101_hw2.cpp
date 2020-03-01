#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int GCD(int a, int b) //function that finds greatest common divisor of two numbers
{
    if (b == 0)
        return a;
    return GCD(b, a % b);
}

int DPFarm(vector<int> farmArea, vector<int> farmValue, int totalArea)
{
    if (totalArea == 0)
        return 0;
    vector<int> farmYields; //store the optimal yield for each farm size up to total Area
    farmYields.resize(totalArea + 1);

    for (int area = 1; area <= totalArea; area++)
    {
        for (int i = 0; i < farmArea.size(); i++)
        {
            if (farmArea[i] <= area)
            {
                int subYield = farmYields[area - farmArea[i]] + farmValue[i];
                if (farmYields[area] < subYield)
                    farmYields[area] = subYield; //replace current largest value with new max
            }
        }
    }
    return farmYields[totalArea];
}

//no self-calling
//add a currentCrop parameter so that won't do same computation of diffrent computations
// ex: a->b->c is the same as c->b->a
int recursiveFarm(vector<int> farmArea, vector<int> farmValue, int currentCrop, int totalArea)
{
    if (totalArea == 0)
        return 0;

    int maxSub = 0;

    //solve subproblems
    for (int i = 0; i < farmArea.size(); i++)
    {
        if (totalArea >= farmArea[i] && i >= currentCrop) //enough space to plant crop i
        {
            int yield = recursiveFarm(farmArea, farmValue, i, (totalArea - farmArea[i])) + farmValue[i];
            if (yield > maxSub)
                maxSub = yield;
        }
    }
    return maxSub;
}

// recursive with an additional array storing already-done recursive
int memoizedFarm(vector<int> farmArea, vector<int> farmValue, int totalArea, vector<int> &compRecord)
{
    if (totalArea == 0)
        return 0;

    int maxSub = 0;
    for (int i = 0; i < farmArea.size(); i++)
    {
        if (totalArea >= farmArea[i])
        {
            int yield;
            int subArea = totalArea - farmArea[i];
            if (compRecord[subArea] != 0)
            {
                yield = compRecord[subArea] + farmValue[i];
            }
            else
            {
                int subyield = memoizedFarm(farmArea, farmValue, subArea, compRecord);
                compRecord[subArea] = subyield;
                yield = subyield + farmValue[i];
            }
            if (yield > maxSub)
                maxSub = yield;
        }
    }
    return maxSub;
}

int main(int argc, char **argv)
{
    ifstream infile;
    ofstream outfile;
    infile.open(argv[1]);
    outfile.open(argv[2]);

    int Mode = 2, FieldArea, CropKinds;
    infile >> Mode >> FieldArea >> CropKinds;

    vector<int> farmValue, farmArea;
    farmValue.resize(CropKinds);
    farmArea.resize(CropKinds);

    int AreaGCD = FieldArea;

    for (int i = 0; i < CropKinds; i++)
    {
        infile >> farmArea[i] >> farmValue[i];

        //find GCD and resize FieldArea and field sizes
        AreaGCD = GCD(AreaGCD, farmArea[i]);
    }

    FieldArea = FieldArea / AreaGCD;
    for (int i = 0; i < CropKinds; i++)
    {
        farmArea[i] = farmArea[i] / AreaGCD;
    }

    vector<int> compRecord; //records computations that have been done
    compRecord.resize(FieldArea);

    switch (Mode)
    {
    case 0:
        outfile << recursiveFarm(farmArea, farmValue, 0, FieldArea);
        break;
    case 1:
        outfile << DPFarm(farmArea, farmValue, FieldArea);
        break;
    case 2:
        outfile << memoizedFarm(farmArea, farmValue, FieldArea, compRecord);
        break;
    }
}
