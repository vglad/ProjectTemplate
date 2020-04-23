#ifndef PROJECT_INCLUDE_DETAIL_ERRHANDLER_HPP
#define PROJECT_INCLUDE_DETAIL_ERRHANDLER_HPP

#include <string>
#include <iostream>


namespace detail {

  static void print_nested_exception(const std::exception& e, size_t level =  0) {
    std::cerr << std::string(level, ' ') << "exception: " << e.what() << '\n';
    try {
      // Check if exception has nested exception
      // If not means that it is last level and we simply return
      try {
        if(!dynamic_cast<const std::nested_exception &>(e).nested_ptr()) { return; }
      } catch (...) { return; }

      std::rethrow_if_nested(e);
    } catch(const std::exception& e) {
      print_nested_exception(e, level + 2);
    } catch(...) {}
  }

}

#endif //PROJECT_INCLUDE_DETAIL_ERRHANDLER_HPP

//*****************************************************************************
// Usage example
/*
 void init() {
  try {
      throw std::runtime_error("Runtime error #42");
    }
  } catch (...) {
    std::throw_with_nested(std::runtime_error("Init failed"));
  }

 void server_start {
  try {
    init();
  }
  catch (...) {
    std::throw_with_nested(std::runtime_error("Start failed"));
  }
 }

 int_main {
    try {
      server_start();
    }
    catch (std::exception const &)   {
      print_nested_exception();
    }
 }
*/
//*****************************************************************************
