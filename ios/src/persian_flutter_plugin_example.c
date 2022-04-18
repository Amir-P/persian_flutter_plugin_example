#include <stdbool.h>

char* get_suggestion(double battery, bool is_low_power)
{
    if (battery > 0.8 && is_low_power) {
        return "Turn off low power mode";
    }
    if (battery < 0.2 && !is_low_power) {
        return "Turn on low power mode";
    }
    return "You're fine";
}