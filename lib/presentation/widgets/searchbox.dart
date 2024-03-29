import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/exports.dart';
import '../../constants/color.dart';
import '../../constants/enums/plant_filter.dart';
import '../../constants/enums/status.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'message_snackbar.dart';
import '../../resources/route_manager.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchText = TextEditingController();
  bool _isExpanded = true;
  bool isFilterFullyExpanded = false;
  bool isNameSorted = false;
  bool isDateSorted = false;

  void toggleFilterSize() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void submitSearch() {
    FocusScope.of(context).unfocus();
    if (searchText.text.isEmpty) {
      displaySnackBar(
        status: Status.error,
        message: 'Search term can not be empty',
        context: context,
      );
    }
    print(searchText.text);
    context.read<SearchCubit>().searchKeyword(searchText.text.trim());
  }

  void setFilter({required PlantFilter filter}) {
    print(filter);
    context.read<FilterCubit>().changeFilter(filter);
  }

  void navigateToFilter(BuildContext context) {
    Navigator.of(context).pushNamed(RouteManager.filterPlantScreen);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: _isExpanded ? size.width * 0.8 : size.width * 0.12,
            curve: Curves.easeIn,
            onEnd: () {
              setState(() {
                if (!_isExpanded) {
                  isFilterFullyExpanded = true;
                } else {
                  isFilterFullyExpanded = false;
                }
              });
            },
            child: TextFormField(
              readOnly: _isExpanded ? false : true,
              controller: searchText,
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                  onTap: () => _isExpanded ? submitSearch() : null,
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
          AnimatedContainer(
            curve: Curves.easeIn,
            decoration: _isExpanded
                ? const BoxDecoration()
                : BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppSize.s100),
                  ),
            duration: const Duration(seconds: 1),
            width: _isExpanded ? size.width * 0.12 : size.width * 0.8,
            child: _isExpanded
                ? GestureDetector(
                    onTap: () => toggleFilterSize(),
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
                  )
                : Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => toggleFilterSize(),
                          child: const Icon(
                            Icons.tune,
                            color: primaryColor,
                          ),
                        ),
                        isFilterFullyExpanded
                            ? GestureDetector(
                                onTap: () =>
                                    setFilter(filter: PlantFilter.name),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'Name',
                                      style: getMediumStyle(
                                        color: fontColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.unfold_more,
                                      color: fontColor,
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        isFilterFullyExpanded
                            ? GestureDetector(
                                onTap: () =>
                                    setFilter(filter: PlantFilter.date),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'Date',
                                      style: getMediumStyle(
                                        color: fontColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.unfold_more,
                                      color: fontColor,
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
