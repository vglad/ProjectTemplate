#ifndef PROJECT_INCLUDE_DETAIL_UTILS_HPP
#define PROJECT_INCLUDE_DETAIL_UTILS_HPP

#include <iostream>
#include <sstream>

namespace detail {

  template<typename... T>
    static std::string concat (T const & ... args) {
      std::ostringstream os{};
      (os << ... << args);
      return os.str();
    }

}

#endif //PROJECT_INCLUDE_DETAIL_UTILS_HPP