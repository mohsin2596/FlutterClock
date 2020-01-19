import 'package:flutter_clock_helper/model.dart';

enum AnimationTypes { morning, mid, sunset, night, nightfall }

class AnimHelper {
  static int nightAnimCount = 0;

  static String getAnimationName(
      String condition, int hour, bool animComplete) {
    var animType = AnimationTypes.morning.toString();

    //Hour would be provided in 24hour format
    //Ideally these should be according to realistic values fetched based on location
    //For competition sake these values would be an assumption
    if (hour >= 7 && hour <= 8) {
      animType = animComplete
          ? AnimationTypes.mid.toString()
          : AnimationTypes.morning.toString();
    } else if (hour >= 9 && hour <= 17) {
      animType = AnimationTypes.mid.toString();
    } else if (hour >= 18 && hour <= 19) {
      animType = animComplete
          ? ((nightAnimCount == 1)
              ? AnimationTypes.nightfall.toString()
              : AnimationTypes.night.toString())
          : AnimationTypes.sunset.toString();

      //reset counter
      nightAnimCount = 0;
    } else if (hour >= 20 && hour <= 21) {
      animType = animComplete
          ? AnimationTypes.nightfall.toString()
          : AnimationTypes.night.toString();
    } else {
      animType = AnimationTypes.nightfall.toString();
    }

    return enumToString(animType);
  }
}
