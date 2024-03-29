import 'package:blockcorp/features/countries/domain/entities/countries.dart';
import 'package:blockcorp/features/countries/presentation/controllers/countries/countries_controller.dart';
import 'package:blockcorp/features/countries/presentation/widgets/country_item.dart';
import 'package:blockcorp/features/countries/presentation/widgets/custom_button.dart';
import 'package:blockcorp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountriesListPage extends StatelessWidget {
  CountriesListPage({Key? key, required this.selectedCountries})
      : super(key: key);
  final List<Countries>? selectedCountries;

  final CountriesController _controller = Get.put(sl<CountriesController>());
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29), color: Colors.blue),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Colors.white,
                      onChanged: (text) {
                        _controller.searchCountry(text);
                      },
                      cursorWidth: 1,
                      decoration: InputDecoration(
                          hintText: 'search',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 15),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
                child: GetBuilder(
                    init: _controller,
                    initState: (_) {
                      _controller.fetchData(selectedCountries ?? []);
                      scrollController.addListener(() {
                        if (scrollController.offset ==
                            scrollController.position.maxScrollExtent) {
                          _controller.fetchData(_controller.countriesList
                              .where((element) => element.isSelected == true)
                              .toList());
                        }
                      });
                    },
                    builder: (_) {
                      if (_controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (_controller.error != null) {
                        return Text(_controller.error ?? '');
                      }
                      return ListView.builder(
                          itemCount: _controller.searchtList.length,
                          controller: scrollController,
                          itemBuilder: ((context, index) {
                            return CountryItem(
                              commonName:
                                  _controller.searchtList[index].commonName ??
                                      '',
                              officialName:
                                  _controller.searchtList[index].officialName ??
                                      '',
                              hasCheckbox: true,
                              checkboxValue:
                                  _controller.searchtList[index].isSelected,
                              onChanged: (value) {
                                _controller.changeSelectedValue(
                                    _controller.searchtList[index]);
                              },
                            );
                          }));
                    })),
            CustomButton(
              name: 'Done',
              onPressed: () {
                Navigator.pop(
                    context,
                    _controller.countriesList
                        .where((element) => element.isSelected == true)
                        .toList());
              },
            )
          ],
        ),
      ),
    );
  }
}
