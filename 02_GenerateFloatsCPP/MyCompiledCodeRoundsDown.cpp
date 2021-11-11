// return result of (1) 2/3 , (2) 15/8, (3) 17/8
//
// Compile: g++ -o MyCompiledCodeRoundsDown MyCompiledCodeRoundsDown.cpp
// Execution: ./MyCompiledCodeRoundsDown
//

#include <iostream>

int main(){
    int firstTest =2;
    int secondTest =15;
    int thirdTest =17;

    int firstDivisor =3;
    int secondDivisor =8;

    std::cout << "1) " << firstTest / firstDivisor  << std::endl;
    std::cout << "2) " << secondTest / secondDivisor << std::endl;
    std::cout << "3) " << thirdTest / secondDivisor << std::endl;
    return 0;
}
