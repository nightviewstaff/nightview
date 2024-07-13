import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class FavoriteClubButton extends StatefulWidget {
  const FavoriteClubButton({super.key});

  @override
  State<FavoriteClubButton> createState() => _FavoriteClubButtonState();
}

class _FavoriteClubButtonState extends State<FavoriteClubButton> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GlobalProvider provider = Provider.of<GlobalProvider>(context, listen: false);
      provider.setChosenClubFavoriteLocal(provider.chosenClubFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        GlobalProvider provider = Provider.of<GlobalProvider>(context, listen: false);

        String? userId = provider.userDataHelper.currentUserId;
        String clubId = provider.chosenClub.id;

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Der skete en fejl',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
          );
          return;
        }

        bool isFavorite = provider.chosenClubFavoriteLocal;
        if (isFavorite) {
          // Remove favorite club
          provider.clubDataHelper.removeFavoriteClub(clubId, userId);
          provider.setChosenClubFavoriteLocal(false);
        } else {
          // Add favorite club
          bool doFavorite = await _showConfirmationDialog(context);
          if (doFavorite) {
            provider.clubDataHelper.setFavoriteClub(clubId, userId);
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    bool doFavorite = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Tilføj favorit',
          style: TextStyle(color: primaryColor),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Ved at tilføje en klub som favorit giver du lov til at denne klub/bar sender dig beskeder om deres tilbud.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              doFavorite = false;
              Navigator.of(context).pop();
            },
            child: Text(
              'Fortryd',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fortsæt',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
    return doFavorite;
  }
}
