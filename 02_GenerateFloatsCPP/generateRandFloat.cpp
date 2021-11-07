// // Quick hack to generate floats
// #include <iostream>
// #include <cstdlib>

// int main(){
//   std::cout << "Generating floats..." << std::endl;
//   for(int i = 0; i < 100; i++){
//     std::cout << "float " << i << " = " << (float)rand()/RAND_MAX << ";" << std::endl;
//   }

//   // Generate random longs
//   std::cout << "Generating longs..." << std::endl;
//   for(int i = 0; i < 100; i++){
//     // Random max value 64 bit int
//     std::cout << "long long" << i << " = " << (long long)rand() << ";" << std::endl;
//     // std::cout << "long " << i << " = " << (long)rand()/RAND_MAX << ";" << std::endl;
//   }

//   return EXIT_SUCCESS;
// }

// https://stackoverflow.com/questions/22883840/c-get-random-number-from-0-to-max-long-long-integer
#include <iostream>
#include <random>
#include <limits>
#include <chrono>
#include <string>
// #include <numeric>

#https://stackoverflow.com/questions/17223096/outputting-date-and-time-in-c-using-stdchrono
std::string getTimeStr(){
    std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());

    std::string s(30, '\0');
    std::strftime(&s[0], s.size(), "%Y-%m-%d %H:%M:%S", std::localtime(&now));
    return s;
}

int main(int argc, char *argv[]) {
  std::random_device rd;     //Get a random seed from the OS entropy device, or whatever
  std::mt19937_64 eng1(rd()); //Use the 64-bit Mersenne Twister 19937 generator
                             //and seed it with entropy.

  //Define the distribution, by default it goes from 0 to MAX(unsigned long long)
  //or what have you.
  std::uniform_int_distribution<unsigned long long> distr;

  //Generate random numbers
  auto old=1.0;
  auto toggle = true;
  int range;
  // if no input, then default range to 100

  auto dateAndTime = getTimeStr();
  std::cout << "-- Generated at: " << dateAndTime << std::endl;

  if (argc == 1) {
    std::cout << "-- No int provided, defaulted to 100!" << std::endl;
    range = 100;

  } else {
    range = atoi(argv[1]);
    std::cout << "-- Using provided int of '" << range <<"'!" << std::endl;
  }

  for(int n=0; n<range; n++){
    // std::random_device rd2;     //Get a random seed from the OS entropy device, or whatever
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::subtract_with_carry_engine<unsigned,24,10,24> eng2(seed);

    float val1 = distr(eng1);
    float val2 = eng2();

    if (val2 < 0.0000000 && val2 > -0.0000000) {
      val2 = 1.0;
    }

    auto result = val1/val2;

    float partial = old/result;

    // std::cout << std::to_string(result) << "[Partial -- " << partial << "]" << std::endl;
    if (toggle) {
      result = result-partial;
    } else {
      result = result/partial*(-1)+partial;
    }

    std::cout << std::to_string(result) << std::endl; //<< "[Partial -- " << partial << "]" 
    old = result;
    toggle = !toggle;

  }
  std::cout << std::endl;
}