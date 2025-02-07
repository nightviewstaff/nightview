//
//
// class _CustomSearchBarState extends State<CustomSearchBar> {
//   late FloatingSearchBarController _controller;
//
// }
//
// @override
// void initState() {
//   super.initState();
//   _controller = FloatingSearchBarController();
// }
//
// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }
//
// @override
// Widget build(BuildContext context) {
//   return Consumer<GlobalProvider>(
//     builder: (context, globalProvider, _) {
//       return FloatingSearchBar(
//         controller: _controller,
//         automaticallyImplyBackButton: false,
//         clearQueryOnClose: false,
//         transitionDuration: const Duration(milliseconds: 300),
//         hint: 'Search clubs...',
//         hintStyle: kTextStyleP3,
//         border: BorderSide.none,
//         margins: EdgeInsets.zero,
//         padding: EdgeInsets.zero,
//         iconColor: primaryColor,
//         debounceDelay: const Duration(milliseconds: 200),
//         onQueryChanged: (query) {
//           context.read<SearchProvider>().updateSearch(
//             query,
//             globalProvider.lastKnownPosition?.toLatLng(),
//           );
//         },
//         onFocusChanged: (isFocused) {
//           if (!isFocused) _controller.close();
//         },
//         builder: (context, transition) {
//           return _buildSearchResults();
//         },
//         body: FloatingSearchBarScrollNotifier(
//           child: Container(), // Empty container since map is behind
//         ),
//       );
//     },
//   );
// }
//
//
// Widget _buildFilterToggles(BuildContext context) {
//   final searchProvider = Provider.of<SearchProvider>(context, listen: false);
//
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildToggleButton(Icons.access_time, "Open Now", searchProvider.showOnlyOpen, searchProvider.toggleShowOnlyOpen),
//         _buildToggleButton(Icons.location_on, "Nearby", searchProvider.sortByDistance, searchProvider.toggleSortByDistance),
//         _buildToggleButton(Icons.favorite, "Favorites", searchProvider.showFavoritesOnly, searchProvider.toggleShowFavoritesOnly),
//         _buildRatingSlider(context),
//       ],
//     ),
//   );
// }
//
// Widget _buildToggleButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Column(
//       children: [
//         Icon(icon, color: isActive ? Colors.blue : Colors.grey),
//         Text(label, style: TextStyle(color: isActive ? Colors.blue : Colors.grey, fontSize: 12)),
//       ],
//     ),
//   );
// }
//
// Widget _buildRatingSlider(BuildContext context) {
//   final searchProvider = Provider.of<SearchProvider>(context, listen: false);
//
//   return Column(
//     children: [
//       Text("Min. Rating", style: TextStyle(fontSize: 12)),
//       Slider(
//         value: searchProvider.minRating.toDouble(),
//         min: 0,
//         max: 5,
//         divisions: 5,
//         label: "${searchProvider.minRating}+",
//         onChanged: (value) {
//           searchProvider.setMinRating(value.toInt());
//         },
//       ),
//     ],
//   );
// }
//
// Widget _buildSearchResults(List<ClubData> clubs) {
//   return ListView.builder(
//     shrinkWrap: true,
//     itemCount: clubs.length,
//     itemBuilder: (context, index) {
//       final club = clubs[index];
//
//       return ListTile(
//         leading: CircleAvatar(
//           backgroundImage: CachedNetworkImageProvider(club.logo),
//           radius: 25,
//         ),
//         title: Text(club.name),
//         subtitle: Text("${club.rating} ⭐ | ${club.totalPossibleAmountOfVisitors} Capacity"),
//         onTap: () {
//           widget.onClubSelected(LatLng(club.lat, club.lon));
//         },
//       );
//     },
//   );
// }
//
// Widget _buildSearchResults1() {
//   return Consumer<SearchProvider>(
//     builder: (context, searchProvider, _) {
//       if (searchProvider.filteredClubs.isEmpty) {
//         return const Center(child: Text('No results found'));
//       }
//
//       return ListView.separated(
//         padding: const EdgeInsets.only(top: 8),
//         itemCount: searchProvider.filteredClubs.length,
//         separatorBuilder: (_, __) => const Divider(height: 1),
//         itemBuilder: (context, index) {
//           final club = searchProvider.filteredClubs[index];
//           return _ClubSearchResultTile(
//             club: club,
//             onTap: () => widget.onClubSelected(
//               LatLng(club.lat, club.lon),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//
// Widget _buildSearchResults() {
//   return Consumer<SearchProvider>(
//       builder: (context, searchProvider, _) {
//     if (searchProvider.filteredClubs.isEmpty) {
//       return const Center(child: Text('No results found'));
//     }