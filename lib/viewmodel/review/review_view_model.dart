import 'package:get/get.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';

class ReviewViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxString _selectedCategory = '전체'.obs;

  final RxList<ReviewListModel> _allReviews = <ReviewListModel>[].obs;

  final RxList<ReviewListModel> _filteredReviews = <ReviewListModel>[].obs;

/* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<String> get categories => ['전체', '정보처리기사', '컴퓨터활용능력1급','한국사능력검정시험'];

  String get selectedCategory => _selectedCategory.value;
  List<ReviewListModel> get filteredReviews => _filteredReviews;
  List<ReviewListModel> get allReviews => _allReviews;


  @override
  void onInit() {
    super.onInit();
    _loadReviewsData();
    _applyFilter();
  }

  void selectCategory(String category) {
    _selectedCategory.value = category;
    _applyFilter();
  }

  void _applyFilter() {
    if (_selectedCategory.value == '전체') {
      _filteredReviews.value = _allReviews;
    } else {
      _filteredReviews.value = _allReviews
          .where((exam) => exam.certificate == _selectedCategory.value)
          .toList();
    }
  }

  void _loadReviewsData() {
    _allReviews.addAll([
      ReviewListModel(review_note_id: "re220481hdheu",
          exam_id: "info2810853fd",
          name: "2023년 정보처리기사 제 1회",
          is_passed: true,
          certificate: "정보처리기사",
          read_count: 1,
          pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853ff", name: "2023년 정보처리기사 제 2회", is_passed: true, certificate: "정보처리기사", read_count: 3, pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853fx", name: "2022년 정보처리기사 제 3회", is_passed: false, certificate: "정보처리기사", read_count: 1, pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853fh", name: "2024년 한국사능력검정시험 7월", is_passed: true, certificate: "한국사능력검정시험", read_count: 2, pass_rate: 70),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2023년 컴퓨터활용능1급 제 5회", is_passed: true, certificate: "컴퓨터활용능1급", read_count: 3, pass_rate: 58.56),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2024년 컴퓨터활용능1급 제 3회", is_passed: false, certificate: "컴퓨터활용능1급", read_count: 2, pass_rate: 72.44),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2025년 컴퓨터활용능1급 제 1회", is_passed: true, certificate: "컴퓨터활용능1급", read_count: 1, pass_rate: 40.55)
    ]);
  }

}