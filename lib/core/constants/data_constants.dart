const String contactNumber = "067641000";
const String contactEmail = "info@uaqgov.ae";
const String contactWhatsAppLink = "https://wa.me/971569901116";
const String ambulanceNumber = "998";
const String policeNumber = "999";
const String civilDefenseNumber = "997";
const String electricityNumber = "991";
const String waterNumber = "992";
const String servicesInListView = "LIST";
const String servicesInGridView = "GRID";
const int maxUploadFilesize = 1024 * 1024;

const mobileRegx = r'^05[0-9]{8}$';
const emailTemplatePath = 'assets/json/email_template.txt';
const requestService = 'assets/json/request_service.json';

final pendingActionTypes = [
  'pending service fees payment',
  'pending lab fee payment',
  //'pending arrival confirmation',
  'pending fine fee payment',
  'pending_fine_fee_payment',
  'pending_service_fee_payment',
  'pending app fee payment',
  'pending adv fees payment',
  'partner approval',
  'pending app service fee payment',
  'pending service fee payment',
  //'pending resubmit',
  'save draft',
  'new'
];
