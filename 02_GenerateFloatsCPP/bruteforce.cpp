#include <iostream>
#include <string>

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

std::string convertIntToHex(int number) {
    std::string hex = "";

    std::cin >> number;
    while (number > 0) {
        int remainder = number % 16;
        if (remainder < 10) {
            hex += remainder + 48;
        } else {
            hex += remainder + 55;
        }
        number /= 16;
    }
    return hex;
}

int main(){
  std::cout << convertIntToHex(100231);
  return EXIT_SUCCESS;
}

