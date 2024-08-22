//smartUAQ server ports
const String defaultPort = "8080";
const String communicationPort = "5003";
const String oracleServicePort = "5005";
const String cachingPort = "5002";
const String integrationPort = "5006";
const String sharePointPort = "5001";
const String municipalityServicePort = "";
const String portalPort = "6700";
const String chatbotPort = "443";
const String chabotResourcesPort = "3000";
const String happinessMeterPort = "55122";
const String notificationsPort = "5008";
const String port56711 = "56711";
//smartUAQ service Urls
const String allServicesApiUrl = ':$sharePointPort/api/ServiceCatalogue/GetAll';
const String mostServicesApiUrl =
    ':$oracleServicePort/User/GetMostServicesHits';
const String serviceDetailsApiUrl =
    'UAQMUN_MOB_MD_GetServiceDetails/ServiceData';

//User Urls
const String uaePassLoginApiUrl = ':$integrationPort/UAEPass';
const String credentialsLoginApiUrl = ':$oracleServicePort/Login';
const String getUserDataApiUrl = ':$oracleServicePort/Profile';
const String getEstablishmentsApiUrl =
    ':$oracleServicePort/Profile/GetApplicantEstablishments/';
//const String myNotificationsApiUrl = ':$oracleServicePort/Request/getRequests';
const String myNotificationsApiUrl =
    ':$notificationsPort/PushNotification/GetNotifications';
const String clearNotificationsApiUrl =
    ':$notificationsPort/PushNotification/RemoveNotifications';
const String updateFireBaseTokenApiUrl =
    ':$oracleServicePort/User/UpdateFirebaseToken';
const String sendEmailSupportApiUrl =
    'UAQMUN_MOB_EmailNotificationRequest/sendEmailNotification';

//Wallet Urls
const String getRequestsDetails = 'UAQMUN_MOB_MD_GetRequestDetails/ReqDetails';
const String getMyRequestsApiUrl = 'UAQMUN_MOB_MD_GetRequestList/RequestList';
const String getMyFinesApiUrl = ':$integrationPort/Dashboard/GetFineDashboard';
const String getMyFinesMDApiUrl =
    'UAQMUN_MOB_MD_GetApplicantFinesList/FinesList';
const String getMyEstFinesMDApiUrl =
    'UAQMUN_MOB_MD_GetEstFinesLIst/EstFinesLIst';
const String getMyPaymentApiUrl = ':$oracleServicePort/Payment';
const String myRequestsPortalApiUrl = ':$oracleServicePort/Request/getRequests';
const String myDocumentsApiUrl = 'UAQMUN_MOB_MD_GetDocuments/MyDocs';
const String myLicenseApiUrl =
    ':$integrationPort/Dashboard/GetLicenseDashboard';
const String myPermitsApiUrl =
    ':$integrationPort/Dashboard/GetPermitDashboardWithPagnation';

// Document Verification
const String sessionIdApiUrl = ":$oracleServicePort/User/GetSessionId/";
const String sendOTPToMobileApiUrl = ":$communicationPort/SMS/SendSMSOTP";
const String verifySMSOTP = ":$integrationPort/Activation/VerifySMSOTP/";
const String sendMailToUAQApiUrl = ":$communicationPort/Email/SendMailToUAQ";
const String verfiyDocumentMoblieApiUrl =
    ":$oracleServicePort/api/DocumentVerfication/VerfiyDocumentMoblie";
const String getDocumentApiUrl = ":$oracleServicePort/Documnet/GetDocument";
const String getUserDocumentApiUrl =
    ":$oracleServicePort/Documnet/DownloadDocument";

//Police Domain Urls
const String reportACase = "reportAcase";
const String reportCaseOTPValidation = "reportAcaseOtpValidation";
const String reportCaseResendOTP = "resendOtp";

//Mycity Urls
const String myCityProblemCategoriesApiUrl =
    ':$sharePointPort/api/mycity/GetCategories/';
const String myCityProblemSubmitApiUrl =
    ':$sharePointPort/api/mycity/UploadTicket/';

//requests urls

const String myRequestFormApiUrl = ':$port56711/EService/api/Service/Get/';
const String baseServiceFormApiUrl = ':$port56711/Administration/api/';
const String uploadAttachmentUrl =
    '${baseServiceFormApiUrl}Documents/UploadRequestDocument';
const String requestSubmitFormApiUrl =
    ':$port56711/EService/api/Request/SubmitRequest';
const String requestPaymentFormApiUrl =
    ':$port56711/EService/api/Request/RequestPay';
const String requestStatusApiUrl =
    ':$port56711/EService/api/Request/RequestStatus';
const String happinessMeterApiUrl =
    ':$port56711/HappinessMeter/api/happinessMeterService/happiness-list/';
const String submitHappinessMeterApiUrl =
    ':$port56711/HappinessMeter/api/happinessMeterAnswer';

const String apiFolderUrl = 'api/';
const String validateUserApiUrl = '${apiFolderUrl}User/ValidateUser';
const String userDetailsApiUrl = '${apiFolderUrl}User/GetUserDetails';
const String dashboardApiUrl = '${apiFolderUrl}Dashboard/GetDashboard';
const String subcategoriesApiUrl = '${apiFolderUrl}MasterData/GetSubCategories';
const String reasonsApiUrl = '${apiFolderUrl}MasterData/GetReasons';
const String eservicesApiUrl = '${apiFolderUrl}MasterData/GetEservices';
const String departmentsApiUrl = '${apiFolderUrl}MasterData/GetDepartments';
const String employeesApiUrl = '${apiFolderUrl}MasterData/GetEmployees';
const String assignedEmployeesApiUrl =
    '${apiFolderUrl}MasterData/GetAssignedEmployees';
const String previousAssignedEmployeesApiUrl =
    '${apiFolderUrl}MasterData/GetPreviousAssignies';
const String createTicketApiUrl = '${apiFolderUrl}CreateTicket';
const String createTicketUploadMultiPartApiUrl =
    '${apiFolderUrl}CreateTicket/UploadMultiPart';
const String ticketHistoryApiUrl = '${apiFolderUrl}Ticket/GetTicketHistory';
const String ticketCommentsApiUrl = '${apiFolderUrl}Ticket/GetTicketComments';
const String ticketsByUserApiUrl = '${apiFolderUrl}Ticket/GetTicketsByUser';
const String updateTicketByStatusApiUrl =
    '${apiFolderUrl}CreateTicket/UpdateTicket';
const String forwordTicketApiUrl = '${apiFolderUrl}CreateTicket/ForwordTicket';
