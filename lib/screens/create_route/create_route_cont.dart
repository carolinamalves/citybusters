import 'package:citybusters/controllers/auth/auth_cont.dart';
import 'package:citybusters/models/cb_place.dart';
import 'package:citybusters/models/cb_route.dart';
import 'package:citybusters/screens/search_place/search_place_screen.dart';
import 'package:citybusters/services/storage/storage_references.dart';
import 'package:citybusters/services/storage/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanoid/nanoid.dart';

class CreateRouteCont extends GetxController {
  final name = RxnString();
  final description = RxnString();

  final waypoints = RxList<CBPlace>();
  final startPlace = Rxn<CBPlace>();
  final endPlace = Rxn<CBPlace>();

  final _error = RxnString();
  String get error => _error.value ?? '';

  final image = Rxn<XFile>();
  final _imagePicker = ImagePicker();

  final loading = RxBool(false);

  @override
  void onInit() {
    name.listen((_) {
      if (_error.value != null) _error.value = null;
    });
    description.listen((_) {
      if (_error.value != null) _error.value = null;
    });
    waypoints.listen((_) {
      if (_error.value != null) _error.value = null;
    });
    startPlace.listen((_) {
      if (_error.value != null) _error.value = null;
    });
    endPlace.listen((_) {
      if (_error.value != null) _error.value = null;
    });
    super.onInit();
  }

  void onPlacePointRemove(CBPlace? place) {
    print("on remove called");
    if (place == null) return;

    try {
      if (startPlace.value?.id == place.id) {
        startPlace.value = null;
      } else if (endPlace.value?.id == place.id) {
        endPlace.value = null;
      } else {
        waypoints.removeWhere((_w) => _w.id == place.id);
      }
    } catch (_) {
      // say something
    }
  }

  Future addPlacePoint(int? index, {CBPlace? place}) async {
    final res = await Get.to(() => SearchPlace());
    if (!(res is CBPlace)) {
      // say something
      return;
    }

    try {
      if (place != null) {
        final _i = waypoints.indexWhere((_w) => _w.id == place.id);
        waypoints[_i] = res;
      } else if (index == null) {
        waypoints.add(res);
      } else if (index == -1) {
        startPlace.value = res;
      } else if (index == -2) {
        endPlace.value = res;
      }
    } catch (_) {
      // say something
    }
  }

  onName(String _v) => name.value = _v;
  onDescription(String _v) => description.value = _v;

  void onImageTap() async {
    final _pi = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_pi is XFile) image.value = _pi;
  }

  void onImageDeleteTap() {
    image.value = null;
  }

  void createRoute() async {
    if (image.value == null) {
      _error.value = 'You have to pick an image.';
      return;
    }

    if (name.value?.trim().isEmpty ?? true) {
      _error.value = 'The route name must not be empty.';
      return;
    }

    if (startPlace.value == null) {
      _error.value = 'You must specify a start place';
      return;
    }

    if (endPlace.value == null) {
      _error.value = 'You must specify an end place';
      return;
    }

    loading.value = true;

    final routeId = nanoid();
    final url = await StorageService.uploadFile(
      path: StorageReferences.routeCover(routeId),
      file: image.value!,
    );

    final route = CBRoute(
      id: routeId,
      name: name.value!.trim(),
      coverUrl: url,
      creatorId: Get.find<AuthCont>().userId,
      places: [startPlace.value!, ...waypoints, endPlace.value!],
      description: description.value?.trim(),
    );

    loading.value = false;

    await FirebaseFirestore.instance
        .collection('routes')
        .doc(routeId)
        .set(route.toJson());

    Get.back();
  }
}
