import 'dart:math';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:nightview/utilities/club_data/club_opening_hours_formatter.dart';

class ClubCapacityCalculator {
  static double displayCalculatedPercentageOfCapacity(ClubData club) {
    return calculateCurrentCapacityPercent(club);
  }

  static double calculateCurrentCapacityPercent(ClubData club) {
    double percentOfCapacity =
        club.visitors / club.totalPossibleAmountOfVisitors;

    if (percentOfCapacity <= 0.1) {
      final Random random = Random(42);
      percentOfCapacity =
          (10 + random.nextInt(7)) / 100; // set to between 10% and 16%)
    }
    if (percentOfCapacity > 0.95) {
      percentOfCapacity = 0.95; // Cap at 95%
    }
    if (ClubOpeningHoursFormatter.formatOpeningHours(club) == 'Lukket i dag.') {
      percentOfCapacity = 0;
    } // TODO Figure out exact time. (if open at 18 and is 17 still say 0)
    return percentOfCapacity;
  }
}
