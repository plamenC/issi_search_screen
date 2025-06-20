import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/court_case_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isDropdownOpen = false;
  final FocusNode dropdownFocusNode = FocusNode();
  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController caseTypeController = TextEditingController();

  @override
  void dispose() {
    dropdownFocusNode.dispose();
    caseNumberController.dispose();
    yearController.dispose();
    caseTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 20),
                  child: const Text(
                    'Търсене на дело',
                    style: TextStyle(
                      fontFamily: 'Verdana',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2, // 24px / 20px = 1.2
                      letterSpacing: 0.1, // 0.5% of 20px
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 4),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: caseNumberController,
                          onSubmitted: (value) {
                            debugPrint('Plamen:Дело номер: $value');
                          },
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5, // 24px / 16px = 1.5
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Номер',
                            labelStyle: const TextStyle(
                              color: Color(0xFF9596A1),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xFF1A237E),
                            ),
                            hintText: '...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF1B1C28),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF9596A1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF1A237E),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              bottom: 4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24), //the gap between the fields
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: yearController,
                          onSubmitted: (value) {
                            debugPrint('Plamen:Година: $value');
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5, // 24px / 16px = 1.5
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Година',
                            labelStyle: const TextStyle(
                              color: Color(0xFF9596A1),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xFF1A237E),
                            ),
                            hintText: DateTime.now().year.toString(),
                            hintStyle: const TextStyle(
                              color: Color(0xFF1B1C28),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF9596A1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF1A237E),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              bottom: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            final options = [
                              'Административно дело',
                              'Търговско дело',
                              'Частно наказателно дело',
                              'Въззивно частно гражданско дело',
                            ];
                            return options.where(
                              (option) => option.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                            );
                          },
                          fieldViewBuilder:
                              (
                                context,
                                textEditingController,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onTap: () {
                                    setState(() {
                                      isDropdownOpen = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      isDropdownOpen = value.isNotEmpty;
                                    });
                                    caseTypeController.text = value;
                                  },
                                  onSubmitted: (value) {
                                    setState(() {
                                      isDropdownOpen = false;
                                    });
                                    onFieldSubmitted();
                                  },
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.5,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Тип дело',
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF9596A1),
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Color(0xFF1A237E),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isDropdownOpen = !isDropdownOpen;
                                          if (isDropdownOpen) {
                                            focusNode.requestFocus();
                                          } else {
                                            focusNode.unfocus();
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Icon(
                                          isDropdownOpen
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF9596A1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1A237E),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      left: 16,
                                      top: 4,
                                      bottom: 4,
                                    ),
                                  ),
                                );
                              },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Column(
                              children: [
                                const SizedBox(height: 20),
                                Material(
                                  elevation: 4,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 0),
                                    itemBuilder: (context, index) {
                                      final option = options.elementAt(index);
                                      return ListTile(
                                        title: Text(
                                          option,
                                          style: const TextStyle(
                                            color: Color(0xFF1B1C28),
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        onTap: () {
                                          onSelected(option);
                                          caseTypeController.text = option;
                                          setState(() {
                                            isDropdownOpen = false;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  // SEARCH button
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final caseNumber = caseNumberController.text;
                        final year = yearController.text;
                        final caseType = caseTypeController.text;

                        debugPrint('Plamen: Search button pressed');
                        debugPrint('Plamen: Номер: $caseNumber');
                        debugPrint('Plamen: Година: $year');
                        debugPrint('Plamen: Тип дело: $caseType');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89B82A),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Търси',
                            style: TextStyle(
                              fontFamily: 'Verdana',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              letterSpacing: 0.1,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.search,
                            color: Color(0xFFFFFFFF),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: 10,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12), //the gap between cards
              itemBuilder: (context, index) {
                return CourtCaseCard(
                  //TODO: change to real data, once we are ready
                  caseNumber: "${1000 + index}",
                  year: "${2020 + (index % 6)}",
                  hasUnreadNotifications: index % 3 == 0,
                  isFollowed: index % 2 == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
