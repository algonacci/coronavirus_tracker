import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  EndpointCardData(this.title, this.assetName, this.color);
  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key? key, required this.endpoint, required this.value})
      : super(key: key);
  final Endpoint? endpoint;
  final int? value;

  static Map<Endpoint?, EndpointCardData?> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/count.png', Color(0xFFFFF492)),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', Color(0xFFE40000)),
    Endpoint.recovered:
        EndpointCardData('Recovered', 'assets/patient.png', Color(0xFF70A901)),
  };

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardData!.title,
                  // ignore: deprecated_member_use
                  style: Theme.of(context)
                      .textTheme
                      // ignore: deprecated_member_use
                      .headline!
                      .copyWith(color: cardData.color),
                ),
                SizedBox(height: 4),
                SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        cardData.assetName,
                        color: cardData.color,
                      ),
                      Text(
                        formattedValue,
                        // ignore: deprecated_member_use
                        style: Theme.of(context)
                            .textTheme
                            // ignore: deprecated_member_use
                            .display1!
                            .copyWith(
                                color: cardData.color,
                                fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
