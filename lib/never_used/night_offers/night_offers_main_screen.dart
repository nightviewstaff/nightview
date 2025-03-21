import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/widgets/stateless/offer_list_item.dart';
import 'package:provider/provider.dart';

class NightOffersMainScreen extends StatelessWidget {
  const NightOffersMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kBiggerPadding),
      child: ListView(
        children: [
          Center(
            child: Text(
              'TOP OFFERS',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: kNormalSpacerValue,
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: Swiper(
              itemCount: 5,
              autoplay: true,
              pagination: SwiperPagination(),
              itemBuilder: (context, index) => Placeholder(),
            ),
          ),
          Text(Provider.of<GlobalProvider>(context)
                  .clubDataHelper
                  .clubData['jagtbar_0']
                  ?.logo ??
              'ERROR'),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
          OfferListItem(
            image: Image.asset('images/logo_icon.png'),
            offer: '2 stk Schmirnoff Ice',
            place: 'Barry\'s',
            price: '9,95',
            onTap: () {
              print('Pressed an item');
            },
          ),
        ],
      ),
    );
  }
}
