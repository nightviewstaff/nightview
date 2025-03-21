import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/app_localization.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class FavoriteClubButton extends StatefulWidget {
  const FavoriteClubButton({super.key});

  @override
  State<FavoriteClubButton> createState() => _FavoriteClubButtonState();
}

class _FavoriteClubButtonState extends State<FavoriteClubButton> {
  int defaultClubAmount = 5;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GlobalProvider provider =
          Provider.of<GlobalProvider>(context, listen: false);

      bool isFavorite =
          await provider.getChosenClubFavorite(); // ✅ Await the async function
      provider.setChosenClubFavoriteLocal(isFavorite); // ✅ Update state safely
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        GlobalProvider provider =
            Provider.of<GlobalProvider>(context, listen: false);

        String? userId = provider.userDataHelper.currentUserId;
        String clubId = provider.chosenClub.id;

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                // AppLocalizations.of(context)!.genericError,
                'Der skete en fejl',
                style: TextStyle(color: redAccent),
              ),
              backgroundColor: black,
            ),
          );
          return;
        }

        bool isFavorite = provider.chosenClubFavoriteLocal;
        if (isFavorite) {
          // Remove favorite club
          bool doRemove = await _showRemoveConfirmationDialog(context);
          if (doRemove) {
            provider.clubDataHelper.removeFavoriteClub(clubId, userId);
            provider.setChosenClubFavoriteLocal(false);
          }
        } else {
          // Check the user's favorite count before adding
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
                  .collection('user_data')
                  .doc(userId)
                  .get();
          List<Map<String, dynamic>> favoriteClubs =
              List<Map<String, dynamic>>.from(userDoc['favorite_clubs'] ?? []);

          // Check if user is admin (admins may bypass the limit)
          bool isAdmin = false;
          try {
            isAdmin = userDoc.get('is_admin') as bool? ?? false;
          } catch (e) {
            print('Error accessing is_admin: $e');
            isAdmin = false; // Treat missing field as false
          }
          if (!isAdmin && favoriteClubs.length >= defaultClubAmount) {
            // Show error dialog if limit reached
            await _showLimitReachedDialog(context);
            return;
          }

          // Add favorite club
          bool doFavorite = await _showConfirmationDialog(context);
          if (doFavorite) {
            provider.clubDataHelper
                .setFavoriteClub(clubId, userId); // Removed context parameter
            provider.setChosenClubFavoriteLocal(true);
          }
        }
      },
      child: FaIcon(
        Provider.of<GlobalProvider>(context).chosenClubFavoriteLocal
            ? FontAwesomeIcons.solidStar
            : FontAwesomeIcons.star,
        color: primaryColor,
      ),
    );
  }

  Future<void> _showLimitReachedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          'For mange favoritter!',
          style: TextStyle(color: redAccent),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Du kan højest have 5 favoritlokationer på samme tid.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Okay',
              style: TextStyle(color: grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    bool doFavorite = true;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          // AppLocalizations.of(context)!.addFavorite,
          'Tilføj favorit',
          style: TextStyle(color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Text(
              // TODO MAKE SURE RIGHT MESSAGE
              // AppLocalizations.of(context)!.addFavouriteDescription,
              'Tilføjer du en lokation som favorit, samtykker du til at modtage tilbudsbeskeder.'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              doFavorite = false;
              Navigator.of(context).pop();
            },
            child: Text(
              // AppLocalizations.of(context)!.cancel,
              'Fortryd',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              // AppLocalizations.of(context)!.continue,
              'Fortsæt',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
    return doFavorite;
  }

  Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
    bool doRemove = false;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          // AppLocalizations.of(context)!.removeFavourite,
          'Fjern favorit',
          style: TextStyle(color: redAccent),
        ),
        content: SingleChildScrollView(
          child: Text(
            // AppLocalizations.of(context)!.confirmRemoveFavourite,
            'Er du sikker på, at du vil fjerne denne klub fra dine favoritter?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              doRemove = false;
              Navigator.of(context).pop();
            },
            child: Text(
              // AppLocalizations.of(context)!.cancel,
              'Fortryd',
              style: TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              doRemove = true;
              Navigator.of(context).pop();
            },
            child: Text(
              // AppLocalizations.of(context)!.remove,
              'Fjern',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    return doRemove;
  }
}
