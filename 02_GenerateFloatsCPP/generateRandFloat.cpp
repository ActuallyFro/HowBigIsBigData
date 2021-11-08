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
#include <sstream>
#include <algorithm>

// https://stackoverflow.com/questions/17223096/outputting-date-and-time-in-c-using-stdchrono
std::string getTimeStr(){
    std::time_t now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());

    std::string s(30, '\0');
    std::strftime(&s[0], s.size(), "%Y-%m-%d %H:%M:%S", std::localtime(&now));

    // Force string Length to '19' (bc: 2021-11-07 10:16:53)
    s.resize(19);

    return s;
}

std::string generateRandUUID(){
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, std::numeric_limits<int>::max());

    std::string uuid;
    std::stringstream ss;

    //get random hexadecimal (length is 8 -- to get to 36: run five times)
    for(int i = 0; i < 5; i++){ //SOME evidence of strings NOT being 8, so for margin...run 5
        ss << std::hex << dis(gen);
    }

    uuid = ss.str();

    // Removed for NOW, since mysql saves an CONCAT operation withOUT them...
    // //add UUID hypens
    // uuid.insert(8, 1, '-');
    // uuid.insert(13, 1, '-');
    // uuid.insert(18, 1, '-');
    // uuid.insert(23, 1, '-');

    // Gives hex string of : 8-4-4-4-12 (32 hexadecimal characters and 4 hyphens) https://en.wikipedia.org/wiki/Universally_unique_identifier
    // uuid.resize(36);    //IF hypens!!!
    uuid.resize(32);

    return uuid;
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

  std::vector<std::string> ListOfUUIDs;

  for(int n=0; n<range; n++){
    auto newUUID = generateRandUUID();

    //-------------------------------------------
    // UUID is the Primary Key, thus it MUST be unique...
    // see if newUUID is already in ListOfUUIDs
    bool alreadyExists = std::find(ListOfUUIDs.begin(), ListOfUUIDs.end(), newUUID) != ListOfUUIDs.end();
    if(alreadyExists){
      //Attempt to do a quick shuffle!
      std::random_shuffle(newUUID.begin(), newUUID.end());

      bool stillExists = std::find(ListOfUUIDs.begin(), ListOfUUIDs.end(), newUUID) != ListOfUUIDs.end();    
      if(stillExists){ //Shuffle found a duplicate UUID, so skip...
        //restart loop, decrement n
        n--;
        continue;
      }
    }
    ListOfUUIDs.push_back(newUUID);
    //-------------------------------------------

    //-----------------------------------------------------
    //GenerateRandom Float:
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
    //-----------------------------------------------------


    std::cout << newUUID << "," << std::to_string(result) << std::endl; //<< "[Partial -- " << partial << "]" 
    old = result;
    toggle = !toggle;

  }
  std::cout << std::endl;
}