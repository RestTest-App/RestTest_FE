abstract class Routes {
  static const String SPLASH = "/splash";
  static const String ON_BOARDING = "/on_boarding";
  static const String LOGIN = "/login";
  static const String ROOT = "/";
  static const String TEST = "/test/info/:testId";
  static const String TEST_EXAM = "/test/exam/:testId";
  static const String TEST_RESULT = "/test/result/:testId";
  static const String TEST_COMMENT = "/test/comment/:testId";
  static const String REVIEW = "/review";
  static const String REVIEW_ITEM = "/review/:reviewId";
  static const String UPDATE_NICKNAME = "/update_nickname";
  static const String TODAY = "/today/info/:todayId";
  static const String TODAY_EXAM = "/today/exam/:todayId";
  static const String TODAY_COMMENT = "/today/comment/:todayId";
  static const String GOAL_SETTING = "/goal/setting";
  static const String ADD_GOAL = "/goal/add";
}
