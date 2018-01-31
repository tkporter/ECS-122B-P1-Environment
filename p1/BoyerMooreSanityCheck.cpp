#include "BoyerMoore.h"
#include "gtest/gtest.h"

using testing::Test;

#include <algorithm>
#include <random>
#include <string>

#define NUM_TEST_CASES 10000
#define RANDOM_STRING_SIZE 100

// Sanity check for BoyerMoore.
// Does NUM_TEST_CASES times:
//    1) Generate random string T of size RANDOM_STRING_SIZE
//    2) Generate a random substring P of T
//    3) Runs BoyerMoore and checks there is at least one match
// Use <random> & uniform_int_distribution for your random number generation
TEST(BoyerMooreSanityCheck, SubstringMatchesInRandomString) {
  // TODO: Implement this
}

int main(int argc, char** argv) {
   testing::InitGoogleTest(&argc, argv);
   return RUN_ALL_TESTS();
}