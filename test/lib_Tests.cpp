#include <catch.hpp>
#include <catch2/trompeloeil.hpp>

#include "lib.hpp"

using namespace library;

TEST_CASE("testing my library", "[lib]") {
  auto l = lib{};

  SECTION("testing addition") {
    REQUIRE(l.addition(1, 41) == 42);
    REQUIRE(l.addition(std::numeric_limits<int32_t>::max(),
                       std::numeric_limits<int32_t>::max()) == 4294967294);
  }

  SECTION("testing throw") {
    REQUIRE_THROWS_AS(l.generate_throw(), std::runtime_error);
  }

}
