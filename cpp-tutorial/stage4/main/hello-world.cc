#include "hello-greet.h"
#include "hello-tick1.h"
#include "hello-tick2000.h"
#include "hello-tick3000.h"
#include <iostream>
#include <string>

void print_localtime() {
  std::time_t result = std::time(nullptr);
  std::cout << std::asctime(std::localtime(&result));
}

int main(int argc, char** argv) {
  std::string who = "world";
  if (argc > 1) {
    who = argv[1];
  }
  std::cout << get_greet(who) << std::endl;
  print_localtime();
  std::cout << get_tick1(who) << std::endl;
  print_localtime();
  std::cout << get_tick2000(who) << std::endl;
  print_localtime();
  std::cout << get_tick3000(who) << std::endl;
  print_localtime();
  return 0;
}
