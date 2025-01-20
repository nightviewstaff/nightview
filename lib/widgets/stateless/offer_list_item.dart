import 'package:flutter/material.dart';
import 'package:nightview/constants/values.dart';

class OfferListItem extends StatelessWidget {

  final Image image;
  final String offer;
  final String price;
  final String place;
  final VoidCallback? onTap;

  const OfferListItem({super.key, required this.image, required this.offer, required this.place, required this.price, this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(kOfferItemPadding),
        child: ListTile(
          leading: image,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                '${price} DKK - ved ${place}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
