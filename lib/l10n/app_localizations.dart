import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ITHELPDESK'**
  String get appTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get thanks;

  /// No description provided for @sorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry'**
  String get sorry;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @appUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your application'**
  String get appUpdateTitle;

  /// No description provided for @appUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'We improve performance and fix some bugs to make your experience seamless'**
  String get appUpdateBody;

  /// No description provided for @whatareyoulookingfor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatareyoulookingfor;

  /// No description provided for @documentSuccessfullySaved.
  ///
  /// In en, this message translates to:
  /// **'Document successfully saved'**
  String get documentSuccessfullySaved;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @directory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get directory;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @searchHere.
  ///
  /// In en, this message translates to:
  /// **'Search here with ticket ID...'**
  String get searchHere;

  /// No description provided for @supportSummary.
  ///
  /// In en, this message translates to:
  /// **'Support Summary'**
  String get supportSummary;

  /// No description provided for @supportSummaryDes.
  ///
  /// In en, this message translates to:
  /// **'The dashboard about the IT Helpdesk Support Tickets'**
  String get supportSummaryDes;

  /// No description provided for @createNewRequest.
  ///
  /// In en, this message translates to:
  /// **'Create New Request'**
  String get createNewRequest;

  /// No description provided for @createNewRequestDes.
  ///
  /// In en, this message translates to:
  /// **'To raise new ticket about your IT issues please fill the simple below form'**
  String get createNewRequestDes;

  /// No description provided for @notAssignedRequests.
  ///
  /// In en, this message translates to:
  /// **'Not Assigned\nRequests'**
  String get notAssignedRequests;

  /// No description provided for @openRequests.
  ///
  /// In en, this message translates to:
  /// **'Open\nRequests'**
  String get openRequests;

  /// No description provided for @closedRequests.
  ///
  /// In en, this message translates to:
  /// **'Closed\nRequests'**
  String get closedRequests;

  /// No description provided for @noOfRequests.
  ///
  /// In en, this message translates to:
  /// **'No. of\nRequests'**
  String get noOfRequests;

  /// No description provided for @ticketsSummary.
  ///
  /// In en, this message translates to:
  /// **'Tickets Summary'**
  String get ticketsSummary;

  /// No description provided for @ticketsSummaryDes.
  ///
  /// In en, this message translates to:
  /// **'The dashboard about the IT Helpdesk Support Tickets'**
  String get ticketsSummaryDes;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @itHelpdeskSupportTickets.
  ///
  /// In en, this message translates to:
  /// **'IT Helpdesk Support Tickets'**
  String get itHelpdeskSupportTickets;

  /// No description provided for @latestTickets.
  ///
  /// In en, this message translates to:
  /// **'Latest Tickets'**
  String get latestTickets;

  /// No description provided for @latestTicketsDes.
  ///
  /// In en, this message translates to:
  /// **'Latest Tickets (Showing 01 to 08 of 48 Tickets)'**
  String get latestTicketsDes;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjects;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @assignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get assignee;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @createDate.
  ///
  /// In en, this message translates to:
  /// **'Create Date'**
  String get createDate;

  /// No description provided for @updateDate.
  ///
  /// In en, this message translates to:
  /// **'Update Date'**
  String get updateDate;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @step1Des.
  ///
  /// In en, this message translates to:
  /// **'Select your Ticket Category'**
  String get step1Des;

  /// No description provided for @step2Des.
  ///
  /// In en, this message translates to:
  /// **'Detail Required'**
  String get step2Des;

  /// No description provided for @step3Des.
  ///
  /// In en, this message translates to:
  /// **'Supported Document'**
  String get step3Des;

  /// No description provided for @supportITRequest.
  ///
  /// In en, this message translates to:
  /// **'IT Support'**
  String get supportITRequest;

  /// No description provided for @itISOCRS.
  ///
  /// In en, this message translates to:
  /// **'ISO CR'**
  String get itISOCRS;

  /// No description provided for @eservices.
  ///
  /// In en, this message translates to:
  /// **'Eservices'**
  String get eservices;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @subCategory.
  ///
  /// In en, this message translates to:
  /// **'Sub Category'**
  String get subCategory;

  /// No description provided for @contactNoTelephoneExt.
  ///
  /// In en, this message translates to:
  /// **'Contact No. / Telephone Ext.'**
  String get contactNoTelephoneExt;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @issueType.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get issueType;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// No description provided for @requestNo.
  ///
  /// In en, this message translates to:
  /// **'Request No.'**
  String get requestNo;

  /// No description provided for @latestUpdate.
  ///
  /// In en, this message translates to:
  /// **'Latest Update'**
  String get latestUpdate;

  /// No description provided for @returnText.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnText;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @chargeable.
  ///
  /// In en, this message translates to:
  /// **'Chargeable'**
  String get chargeable;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @forwardTo.
  ///
  /// In en, this message translates to:
  /// **'Forward to'**
  String get forwardTo;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @selectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get selectDepartment;

  /// No description provided for @selectEmployeeName.
  ///
  /// In en, this message translates to:
  /// **'Select Employee Name'**
  String get selectEmployeeName;

  /// No description provided for @activeRequests.
  ///
  /// In en, this message translates to:
  /// **'Active\nRequests'**
  String get activeRequests;

  /// No description provided for @dueRequests.
  ///
  /// In en, this message translates to:
  /// **'Due\nRequests'**
  String get dueRequests;

  /// No description provided for @allRequests.
  ///
  /// In en, this message translates to:
  /// **'All\nRequests'**
  String get allRequests;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @emailID.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailID;

  /// No description provided for @itSupportDirecotry.
  ///
  /// In en, this message translates to:
  /// **'IT Support Direcotry'**
  String get itSupportDirecotry;

  /// No description provided for @itSupportDirecotryDes.
  ///
  /// In en, this message translates to:
  /// **'Umm Al Quwain Department - IT Support Direcotry'**
  String get itSupportDirecotryDes;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @managerName.
  ///
  /// In en, this message translates to:
  /// **'Manager Name'**
  String get managerName;

  /// No description provided for @yearOfService.
  ///
  /// In en, this message translates to:
  /// **'Year of Service'**
  String get yearOfService;

  /// No description provided for @telephoneExt.
  ///
  /// In en, this message translates to:
  /// **'Telephone Ext'**
  String get telephoneExt;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please Select'**
  String get pleaseSelect;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please Enter'**
  String get pleaseEnter;

  /// No description provided for @enterValid.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid'**
  String get enterValid;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @resubmit.
  ///
  /// In en, this message translates to:
  /// **'Resubmit'**
  String get resubmit;

  /// No description provided for @reAssign.
  ///
  /// In en, this message translates to:
  /// **'Re-Assign'**
  String get reAssign;

  /// No description provided for @reOpen.
  ///
  /// In en, this message translates to:
  /// **'Re-Open'**
  String get reOpen;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @assignedTickets.
  ///
  /// In en, this message translates to:
  /// **'Assigned Tickets'**
  String get assignedTickets;

  /// No description provided for @myTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get myTickets;

  /// No description provided for @employeeTickets.
  ///
  /// In en, this message translates to:
  /// **'Employee Tickets'**
  String get employeeTickets;

  /// No description provided for @noTickets.
  ///
  /// In en, this message translates to:
  /// **'No Tickets'**
  String get noTickets;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @itRequests.
  ///
  /// In en, this message translates to:
  /// **'IT Requests'**
  String get itRequests;

  /// No description provided for @submittingRequest.
  ///
  /// In en, this message translates to:
  /// **'Submitting Request'**
  String get submittingRequest;

  /// No description provided for @successfullySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Successfully Submitted'**
  String get successfullySubmitted;

  /// No description provided for @teamComments.
  ///
  /// In en, this message translates to:
  /// **'Team Comments'**
  String get teamComments;

  /// No description provided for @doYouWantReturnTo.
  ///
  /// In en, this message translates to:
  /// **'Do you want return to'**
  String get doYouWantReturnTo;

  /// No description provided for @doYouWantToResubmit.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Resubmit'**
  String get doYouWantToResubmit;

  /// No description provided for @doYouWantToApprove.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Approve'**
  String get doYouWantToApprove;

  /// No description provided for @doYouWantToForword.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Forword'**
  String get doYouWantToForword;

  /// No description provided for @doYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Do you want to'**
  String get doYouWantTo;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @updatingTicket.
  ///
  /// In en, this message translates to:
  /// **'Updating Ticket'**
  String get updatingTicket;

  /// No description provided for @successfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Successfully Updated'**
  String get successfullyUpdated;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @otherActions.
  ///
  /// In en, this message translates to:
  /// **'Other Actions'**
  String get otherActions;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get vacation;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @tradeLicenseName.
  ///
  /// In en, this message translates to:
  /// **'TradeLicense Name'**
  String get tradeLicenseName;

  /// No description provided for @tradeLicenseNumber.
  ///
  /// In en, this message translates to:
  /// **'TradeLicense Number'**
  String get tradeLicenseNumber;

  /// No description provided for @raisedBy.
  ///
  /// In en, this message translates to:
  /// **'Raised By'**
  String get raisedBy;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @customerEmail.
  ///
  /// In en, this message translates to:
  /// **'Customer Email'**
  String get customerEmail;

  /// No description provided for @customerMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Customer Mobile Number'**
  String get customerMobileNumber;

  /// No description provided for @feedBackRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Improve ItHelpDesk Service'**
  String get feedBackRatingTitle;

  /// No description provided for @feedBackRatingTitleDes.
  ///
  /// In en, this message translates to:
  /// **'Your ticket 00000 has been resolved. Please take a moment to provide feedback on your support experience.'**
  String get feedBackRatingTitleDes;

  /// No description provided for @howWasYourExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasYourExperience;

  /// No description provided for @tellUsMore.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get tellUsMore;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated'**
  String get updatedSuccessfully;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
