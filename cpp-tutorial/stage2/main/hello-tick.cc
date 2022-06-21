#include "hello-tick.h"
#include <string>

std::string get_tick(const std::string& who) {
  return "Hello for tick " + who;
}
