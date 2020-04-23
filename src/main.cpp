#include "Precompiled.hpp"
#include "lib.hpp"

#include <iostream>

using namespace library;
using namespace detail;

int main() {
  try {
    auto l = lib{};
    std::cout << l.addition(1, 41) << '\n';
    l.generate_throw();
  }
  catch (std::exception const & e) {
    print_nested_exception(e);
  }
  return 0;
}
