import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../constants/enums/status.dart';
import '../../resources/values_manager.dart';
import 'message_snackbar.dart';
import '../../resources/route_manager.dart';

class SearchBox extends StatelessWidget {
  SearchBox({super.key});

  final TextEditingController searchText = TextEditingController();

  void submitSearch(BuildContext context) {
    if (searchText.text.isEmpty) {
      displaySnackBar(
        status: Status.error,
        message: 'Search term can not be empty',
        context: context,
      );
    }
  }

  void navigateToFilter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteManager.filterPlantScreen);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            controller: searchText,
            decoration: InputDecoration(
              prefixIcon: GestureDetector(
                onTap: () => submitSearch(context),
                child: const Icon(Icons.search, color: Colors.grey),
              ),
              filled: true,
              fillColor: searchBoxBg,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s100),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s100),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s100),
                borderSide: BorderSide.none,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s100),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToFilter(context),
          child: const CircleAvatar(
            backgroundColor: searchBoxBg,
            radius: 24,
            child: Center(
              child: Icon(
                Icons.tune,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
