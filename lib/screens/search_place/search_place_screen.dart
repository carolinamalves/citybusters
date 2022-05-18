import 'package:citybusters/screens/search_place/search_place_cont.dart';
import 'package:citybusters/widgets/cb_empty_card.dart';
import 'package:citybusters/widgets/cb_place_list_elem.dart';
import 'package:citybusters/widgets/cb_scaffold.dart';
import 'package:citybusters/widgets/cb_screen_loader.dart';
import 'package:get/get.dart';
import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:citybusters/widgets/cb_app_bar.dart';
import 'package:citybusters/widgets/cb_text_input.dart';
import 'package:flutter/material.dart';

class SearchPlace extends StatelessWidget {
  SearchPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SearchPlaceCont>(
      init: SearchPlaceCont(),
      builder: (cont) {
        final results = cont.placesResults;

        return CBScaffold(
          appBar: CBAppBar(
            leading: MapEntry(CBAppBarLeading.back, null),
            title: "Choose Place",
          ),
          body: CBLoader(
            show: cont.loading.isFalse,
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      PSizeConfig.heightSpace(20),
                      CBTextInput(
                        hint: "Type your address...",
                        onQuery: (_query) => cont.query.value = _query,
                      ),
                    ],
                  ),
                ),
                PSizeConfig.SliverHeightSpace(25),
                if (cont.query.trim().isEmpty && results.isEmpty)
                  SliverToBoxAdapter(
                    child: CBEmptyCard(
                      title: 'Search your place',
                      subTitle:
                          'Try to search for nice places\nfor your route!',
                    ),
                  ),
                if (cont.query.trim().isNotEmpty && results.isEmpty)
                  SliverToBoxAdapter(
                    child: CBEmptyCard(
                      title: 'There are no searches',
                      subTitle: 'Try to search for something else.',
                    ),
                  ),
                if (results.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, _i) {
                        return CBPlaceListElem(
                          suggestion: results[_i],
                          onTap: cont.onPlaceTap,
                        );
                      },
                      childCount: results.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
