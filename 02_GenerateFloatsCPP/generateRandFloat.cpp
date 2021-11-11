// https://stackoverflow.com/questions/22883840/c-get-random-number-from-0-to-max-long-long-integer
#include <iostream>
#include <random>
#include <limits>
#include <chrono>
#include <string>
#include <sstream>
#include <algorithm>

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

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

std::string generateSmolUUID() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, std::numeric_limits<int>::max());

    std::string uuid;
    std::stringstream ss;

    // 7-4-4 == 15

    //get random hexadecimal (length is 8 -- to get to 15: run 2 times)
    for(int i = 0; i < 3; i++){ //SOME evidence of strings NOT being 8, so for margin...run 3
        ss << std::hex << dis(gen);
    }

    uuid = ss.str();

    uuid.resize(15);

    return uuid;

}

//Make generic for any length: pass Byte Length; resize WILL equal that.... loops == ByteLength/8 + 1 ----^


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

  int firstByteCounter=0;

  for(unsigned int n=0; n<range; n++){
    // test if range is bigger than C++ MAX unsigned int
    if (range > std::numeric_limits<unsigned int>::max()) {
      std::cout << "-- Range is too big, using C++ MAX unsigned int!" << std::endl;
      range = std::numeric_limits<unsigned int>::max();

      return EXIT_FAILURE;
    }


    // SO UUID is: Gives hex string of : 8-4-4-4-12
    // meaning the 128 bit number can be split into equal groups of 8-4-4 and 4-12
    // which can further have a split to enforce LEADING BYTE selection equally by: 1 | 7-4-4 | 4-12
    // The first byte will simply be rolled from 0 to F, the middle bytes will be random, and the last 16 bytes are the unsigned n counter to cover the FULL unsigneed 64 bit space

    // THIS IS AFWUL, but hopefully FAST
    // (1) FirstByte | (2) smolUUID | (3) fakeUUID

    // 1) FirstByte
    // =============
    std::string FirstByte;

    std::stringstream ss;
    ss << std::hex << firstByteCounter;
    FirstByte = ss.str();

    firstByteCounter++;
    if (firstByteCounter > 15) {
      firstByteCounter = 0;
    }

    // Debug firstBYTE
    // std::cout << "-- FirstByte: " << FirstByte[0] << "(Counter: " << firstByteCounter << ")" << std::endl;

    // 2)smolUUID
    // =============
    // FULL UUID: auto newUUID = generateRandUUID();
    auto smolUUID = generateSmolUUID();


    //3) fakeUUID
    // =============
    ss.clear();
    std::string fakeUUID;
    ss << std::hex << n;
    fakeUUID = ss.str();

    auto TotalBytes= fakeUUID.length();

    auto numMissingBytes = 16 - TotalBytes;
    for (int i = 0; i < numMissingBytes; i++) {
      fakeUUID.insert(0, "0");
    }

    auto newUUID = FirstByte[0] + smolUUID + fakeUUID;

    //BAD!!!
    if(newUUID.length() != 32){
      std::cout << "-- ERROR: UUID length is not 32!" << std::endl;
      n--;
      continue;
    }
    

    //GIVEN the progression of UUID generation... there is NO NEED to check for duplicates!
    // //-------------------------------------------
    // // UUID is the Primary Key, thus it MUST be unique...
    // // see if newUUID is already in ListOfUUIDs
    // bool alreadyExists = std::find(ListOfUUIDs.begin(), ListOfUUIDs.end(), newUUID) != ListOfUUIDs.end();
    // if(alreadyExists){
    //   //Attempt to do a quick shuffle!
    //   std::random_shuffle(newUUID.begin(), newUUID.end());

    //   bool stillExists = std::find(ListOfUUIDs.begin(), ListOfUUIDs.end(), newUUID) != ListOfUUIDs.end();    
    //   if(stillExists){ //Shuffle found a duplicate UUID, so skip...
    //     //restart loop, decrement n
    //     n--;
    //     continue;
    //   }
    // }
    // //-------------------------------------------

   ListOfUUIDs.push_back(newUUID);
 
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