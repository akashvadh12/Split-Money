class NetworkConstantsUtil {
  static const String baseUrl = "https://api.splitmoney.app/v1/";

  // *************** Auth API *************//
  static const String signup =
      'login/signup'; // multipart/form-data (name, email_id, mobile, area_id)
  static const String login = 'login/login'; // (email_id, password)
  static const String logout = 'login/logout';
  static const String forgot_password = 'login/forgot'; // login/forgot/

  // *************** User API *************//
  static const String userProfile = 'login/profile'; 
  static const String updateProfile =
      'login/update';
  static const String changePassword =
      'login/change-password';

  // *************** CMS API *************//
  static const String cmsAboutUs = 'cms/info/about-us';
  static const String cmsContactUs = 'cms/info/contact-us';
  static const String cmsPrivacyPolicy = 'cms/info/privacy-and-policy';
  static const String cmsTerms = 'cms/info/terms-and-conditions';
}
