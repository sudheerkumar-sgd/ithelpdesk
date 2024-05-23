import 'package:smartuaq/res/drawables/drawable_assets.dart';

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
const defaultfavorites = [
  {'ID': 0, 'Icon': DrawableAssets.icFavoriteAdd}
];
const int maxUploadFilesize = 1024 * 1024;

const mobileRegx = r'^05[0-9]{8}$';

const privacyPlocyData = {
  'titleTextEn':
      'Thank you for visiting the SmartUAQ platform. The following privacy policy aims to protect the confidentiality of data provided by our users.',
  'titleTextAr':
      'شكراً لزيارتك لمنصة ام القيوين الذكية. تهدف سياسة الخصوصية التالية إلى حماية سرية البيانات الخاصة بالمستخدم',
  'data': [
    {
      'headerEn': 'Collection and Use of Information',
      'descriptionEn':
          'The following information may be collected anonymously and randomly while using SmartUAQ\n\u2022 IP address of the device you used to access the platform.\n\u2022 The sections and services used while on the platform.\n\u2022 The time, date, and geographical location upon entering the platform.\n\nThe above information is obtained in an aggregate and anonymous manner to improve the performance of SmartUAQ. Such information is not disclosed at all to any other party unless required by law or for the protection of SmartUAQ.\nYour personal information will only be made available to government entities who require the information.\nThis information will not be made publicly available without your consent. Similarly, no such information will be exchanged, sold, or traded with any third party without your prior consent, and access to that information will only be permitted to third party qualified individuals who service the SmartUAQ platform.',
      'headerAr': 'جمع واستخدام المعلومات',
      'descriptionAr':
          'يتم جمع المعلومات التالية على أنها مجهولة المصدر أو عشوائية عند استخدام منصة الشارقة الرقمية\n\u2022 عنوان بروتوكول الإنترنت الخاص بالجهاز الذي تستخدمه للدخول إلى المنصة\n\u2022الأقسام والخدمات المستخدمة خلال تواجدك في المنصة\n\u2022الوقت والتاريخ والموقع الجغرافي عند الدخول إلى المنصة\n\nيتم التعامل مع المعلومات المذكورة أعلاه على أنها مجمّعة ومجهولة المصدر لتحسين أداء منصة ام القيوين الذكية، ولن يتم الإفصاح عن تلك المعلومات لأي طرف إلا وفقاً لما يقتضيه القانون أو لأغراض حماية المنصة.\nسيتم الإفصاح عن بياناتك الشخصية حصراً إلى الهيئات\nالحكومية التي تطلبها، ولن تتم مشاركة بياناتك مع أي طرف آخر إلا بعد موافقتك, كما لن يتم تبادل أو بيع أو مقايضة بياناتك مع أي طرف ثالث إلا بموافقتك بصورة مسبقة، ولا يسمح لأي طرف بالاطلاع على تلك البيانات إلا من قبل الأفراد المصرح لهم والعاملين لدى منصة ام القيوين الذكية.',
    },
    {
      'headerEn': 'Information Security Controls',
      'descriptionEn':
          'SmartUAQ follows strict procedures to protect the privacy of personal information provided by the user. Appropriate encryption is used to protect sensitive Information and any data which must be protected in accordance with legal requirements of the Government of UAQ.',
      'headerAr': 'ضوابط أمن المعلومات',
      'descriptionAr':
          'تتبنى منصة ام القيوين الذكية إجراءات صارمة لحماية الخصوصية وسرية البيانات الشخصية الخاصة بالمستخدم تستخدم المنصة تقنية تشفير ملائمة لحماية المعلومات الحساسة وأي بيانات أخرى يجب حمايتها بموجب قانون حكومة ام القيوين.',
    },
    {
      'headerEn': 'Amendments',
      'descriptionEn':
          'SmartUAQ reserves the right to update or amend the Privacy Policy at any time, provided that the date of such update is stated at the beginning of the policy. The Privacy Policy must be reviewed regularly for any changes.',
      'headerAr': 'ضوابط أمن المعلومات',
      'descriptionAr':
          'تحتفظ منصة ام القيوين الذكية بحقها في تحديث أو تعديل سياسة الخصوصية في أي وقت، شريطة أن يذكر تاريخ التحديث في مستهل السياسة، كما يجب مراجعة سياسة الخصوصية وتحديثها بصورة دورية.',
    },
  ]
};

const termsAndConditionsData = {
  'titleTextEn':
      'Your access to and use of the SmartUAQ platform is subject to the following terms and conditions, in addition to relevant laws and regulations of the United Arab Emirates. By accessing SmartUAQ through either application or website, you agree to these terms and conditions, whether you are a registered user or not. Your use of SmartUAQ means you have accepted these terms and conditions outright.',
  'titleTextAr':
      'إن الوصول إلى "منصة ام القيوين الذكية" واستخدامها، يخضع للشروط والأحكام التالية بالإضافة إلى القوانين واللوائح ذات الصلة في دولة الإمارات العربية المتحدة.\n\nوعند استخدام "منصة ام القيوين الذكية من خلال التطبيق أو الموقع الإلكتروني، فإن المستخدم - سواء كان مسجلاً أم غير مسجل - يوافق تلقائياً على جميع هذه الشروط والأحكام، فمجرد استخدام "منصة ام القيوين الذكية" يعني أن المستخدم وافق على كافة هذه الشروط والأحكام.\n\nوتحتفظ منصة ام القيوين الذكية بالحق في تعديل أي من هذه الشروط والأحكام أو جميعها في أي وقت دون إنذار مسبق، ويوافق المستخدم على الالتزام بهذه التعديلات تلقائياً. يرجى أخذ العلم بأن المؤسسات أو المواقع والصفحات الأخرى المرتبطة بـ"منصة ام القيوين الذكية" تخضع لشروطها وأحكامها الخاصة، ولهذا يرجى زيارة تلك المواقع للاطلاع على الشروط والأحكام الخاصة بها.',
  'data': [
    {
      'headerEn': 'Intellectual Property',
      'descriptionEn':
          'You agree to access and use SmartUAQ for lawful purposes only, and to be fully responsible for your knowledge of and compliance with all laws and regulations regarding your use of SmartUAQ.\nBy accessing SmartUAQ, you agree not to perform any of the following:\n1. Use of SmartUAQ for the purpose of committing a crime or encouraging others to engage in any criminal or illegal conduct or that involves civil liability.\n2. Publishing or posting any unlawful content that includes discrimination, defamation, libel, slander, obscene material, pornographic material, or any other unlawful topic.\n3. Use of SmartUAQ to impersonate other parties or entities.\n4. Upload any harmful or malicious material that may contain software viruses, Trojans, or any other codes, files, or software that may alter, destroy, or stop the functions of the SmartUAQ.\n5. Uploading, entering, emailing, or copying of any material you are not entitled to send under any law or contractual relationship.\n6. Illegal alteration, destruction, or deletion of any content posted on the SmartUAQ platform.\n7. Disruption or impedance of normal communication channels in any way possible.\n8. Claiming a relationship with or representation of any company, association, or entity without being officially authorized by them.\n9. Posting of any materials which violate or interfere with the Intellectual Property Rights of others.\n10. Collection, storage or impersonation of the personal information of others.',
      'headerAr': 'الملكية الفكرية',
      'descriptionAr':
          'يوافق المستخدم على الدخول إلى "منصة ام القيوين الذكية" أو استخدامها لأغراض مشروعة قانوناً فقط، ويتحمل المستخدم المسؤولية الكاملة عن معرفة جميع القوانين واللوائح المتعلقة باستخدام "منصة ام القيوين الذكية" والالتزام بها. عند استخدام "منصة ام القيوين الذكية"، فإن المستخدم يتعهد بعدم القيام بأي من الممارسات التالية:\n.1 استخدام "منصة ام القيوين الذكية" لارتكاب أعمال إجرامية أو تشجيع الآخرين على الانخراط في سلوك إجرامي أو غير قانوني أو ينطوي على مسؤولية مدنية.\n.2 نشر أو إعادة نشر أي محتوى غير قانوني يتضمن التمييز أو التشهير أو القذف أو الافتراء أو المواد الفاحشة أو المواد الإباحية أو أي محتوى غير قانوني.\n.3 استخدام منصة ام القيوين الذكية لانتحال شخصية أطراف أو كيانات أخرى.\n.4 تحميل أي مواد ضارة تحتوي برمجيات فيروسية أو أي شيفرات أو ملفات أو برامج يمكن أن تؤدي إلى تغيير أو إتلاف أو إيقاف عمل "منصة ام القيوين الذكية".\n.5 تحميل أو إدخال أو إرسال بريد إلكتروني أو نسخ أي مادة لا يحق للمستخدم إرسالها بموجب أي قانون أو علاقة تعاقدية. \n.6 تعديل أو إتلاف أو حذف أي محتوى منشور على "منصة ام القيوين الذكية" بطريقة غير قانونية.\n.7 تعطيل أو إعاقة قنوات الاتصال العادية بأي شكل من الأشكال.\n.8 ادعاء وجود علاقة مع أي شركة أو مؤسسة أو جهة أو تمثيلها دون تصريح رسمي منها. \n9.نشر أي مواد تنتهك أو تتعارض مع حقوق الملكية الفكرية للآخرين.\n10 .جمع أو تخزين معلومات الآخرين أو انتحال شخصيتهم.',
    },
    {
      'headerEn': 'Conduct and Behavior',
      'descriptionEn':
          'SmartUAQ follows strict procedures to protect the privacy of personal information provided by the user. Appropriate encryption is used to protect sensitive Information and any data which must be protected in accordance with legal requirements of the Government of UAQ.',
      'headerAr': 'سلوك المستخدم',
      'descriptionAr':
          'بعض أقسام "منصة ام القيوين الذكية" متاحة للمستخدمين المسجلين فقط أو تتيح للمستخدمين طلب الدعم أو الخدمات الأخرى عبر الإنترنت عن طريق إدخال المعلومات الشخصية, وبموجب هذه الخدمات, يوافق المستخدم على تقديم معلومات صحيحة وكاملة ودقيقة، وعلى عدم تسجيل الدخول أو محاولة استخدام "منصة ام القيوين الذكية" بإدخال بيانات شخص آخر، بالإضافة إلى عدم اختيار اسم مستخدم لا تراه "منصة ام القيوين الذكية" مناسباً.',
    },
    {
      'headerEn': 'Login',
      'descriptionEn':
          'SmartUAQ shall be entitled, in its sole discretion, to terminate or suspend your access to or use of the SmartUAQ platform without any prior notice or warning, for any reason whatsoever, including the violation of the terms and conditions or any conduct or behavior which SmartUAQ deems to be unlawful or harmful to others. In the event of termination of use, you will not be allowed to access the platform again, and SmartUAQ will use the right to resort to any means possible to implement such termination.',
      'headerAr': 'تسجيل الدخول',
      'descriptionAr':
          'يحق لـ"منصة ام القيوين الذكية"، وفقًا لتقديرها الخاص, إنهاء أو تعليق وصول المستخدم إلى خدماتها دون أي إشعار مسبق، لأي سبب من الأسباب، بما في ذلك انتهاك أي من الشروط والأحكام أو ارتكاب أي من السلوكيات والممارسات التي تعتبرها "منصة ام القيوين الذكية" غير مشروعة أو تسبب ضرراً للمستخدمين الآخرين في حالة إنهاء الاستخدام, لن يُسمح للمستخدم بالدخول إلى "منصة ام القيوين الذكية" مرة أخرى، وتمتلك المنصة الحق في اتباع كافة الوسائل الممكنة لتنفيذ إنهاء الاستخدام.',
    },
    {
      'headerEn': 'Termination of Access to SmartUAQ',
      'descriptionEn':
          'SmartUAQ reserves the right to monitor any content you enter into the platform. However, it is not obligated to do so. Although SmartUAQ cannot monitor everything entered on the platform, we reserve the right (without obligation) to delete, remove, or edit any material entered that violates the terms and conditions. The UAE and foreign copyright laws and international treaties protect the contents of SmartUAQ. You agree to be bound by copyright notices that appear on this platform.',
      'headerAr': 'إنهاء استخدام "منصة ام القيوين الذكية',
      'descriptionAr':
          'تحتفظ "منصة ام القيوين الذكية" بالحق في مراقبة أي محتوى يدخله المستخدم، حتى لو لم تكن ملزمة بذلك, وعلى الرغم من أن "منصة ام القيوين الذكية" لا تراقب كافة المحتويات التي يتم إدخالها، إلا أنها تحتفظ بالحق دون التزام) في شطب أو إزالة أو تحرير أي مادة تم إدخالها من شأنها انتهاك الشروط والأحكام. محتويات "منصة ام القيوين الذكية" محمية بموجب قوانين حقوق النشر الإماراتية والأجنبية والمعاهدات الدولية ذات الصلة، ويوافق المستخدم على الالتزام بإشعارات حقوق النشر التي تظهر على هذه المنصة.',
    },
    {
      'headerEn': 'Content',
      'descriptionEn':
          'You agree to indemnify, defend and hold SmartUAQ and all of its employees and agents harmless from and against any and all liability, including attorneys fees and costs, incurred in connection with any claim arising out of any breach by you of these Terms and Conditions. You shall cooperate fully in the defense of any such claim in accordance with the rules and regulations of SmartUAQ. The latter reserves the right, at its own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you, and you shall not in any event settle any matter without the written consent of SmartUAQ.',
      'headerAr': 'لمحتوى',
      'descriptionAr':
          'يوافق المستخدم على تعويض وحماية والدفاع عن "منصة ام القيوين الذكية" وموظفيها ووكلائها تجاه أي مسؤولية بما فيها أتعاب المحامين والتكاليف المتعلقة بأي مطالبة ناجمة عن أي انتهاك للشروط والأحكام من جانب المستخدم، ويتوجب على المستخدم أن يتعاون بشكل كامل وفقًا لقواعد وأنظمة "منصة ام القيوين الذكية"، التي تحتفظ بالحق في تولي الدفاع الحصري - على نفقتها الخاصة - أو متابعة أي مسألة تستوجب التعويض من قبل المستخدم، ولا يجوز للمستخدم بأي حال من الأحوال تسوية أي مسألة من دون موافقة خطية من "منصة ام القيوين الذكية".',
    },
    {
      'headerEn': 'Indemnification',
      'descriptionEn':
          'Under no circumstances whatsoever, will SmartUAQ be liable for any accidental, indirect, special, or punitive damages that may arise as a result of your use or inability to use the platform, including but not limited to the loss of income or expected profits, loss of reputation, loss of business, loss of data, computer malfunction, or any other damages.',
      'headerAr': 'التعويض',
      'descriptionAr':
          'لا تتحمل "منصة ام القيوين الذكية المسئولية بأي حال من الأحوال عن الأضرار المباشرة أو غير المباشرة أو الخاصة أو العقابية الناجمة عن استخدام المنصة بما في ذلك - دون الحصر - فقدان الدخل والأرباح المتوقعة أو فقدان السمعة أو الأعمال أو البيانات أو تعطل أجهزة الكمبيوتر أو أي أضرار أخرى.',
    },
    {
      'headerEn': 'Limitation of Liability',
      'descriptionEn':
          'Unless otherwise stated, all Intellectual Property Rights (including trademarks and copyrights) found on SmartUAQ are either owned, controlled, or licensed by the SmartUAQ Office or the government entities from which the content is drawn. As such, the act of consolidation and arrangement of all content on the SmartUAQ platform is the sole property of the Smart UAQ Office and is protected by copyright laws. Smart UAQ Office retains all Intellectual Property Rights in all materials on the platform. The names, trademarks, and logos found on the platform and in the materials therein are owned and licensed for Smart UAQ, unless otherwise stated. The use of these trademarks is prohibited without permission from the Smart UAQ Office or the government entities that they represent.',
      'headerAr': 'حدود المسؤولية',
      'descriptionAr':
          'ما لم تتم الإشارة إلى خلاف ذلك, فإن جميع حقوق الملكية الفكرية بما في ذلك العلامات التجارية وحقوق النشر على "منصة ام القيوين الذكية"، يملكها أن يشرف عليها أو مرخصة من قبل "ام القيوين الذكية أو الهيئات الحكومية التي شاركت بإعداد المحتوى.\nوتبعاً لذلك، تعتبر عملية تجميع وتنظيم المحتوى المتوفر على منصة ام القيوين الذكية ملكية حصرية لدائرة حكومة الذكية ومحمية بموجب قانون حقوق النشر. يحتفظ "دائرة الحكومة الذكية بكافة حقوق الملكية الفكرية الخاصة بالمواد الموجودة على المنصة. كافة الأسماء والعلامات التجارية والشعارات الموجودة على المنصة وفي المواد الواردة في هذه الوثيقة مملوكة ومرخصة لصالح منصة ام القيوين الذكية ما لم تتم الإشارة إلى خلاف ذلك. يمنع استخدام العلامات التجارية دون إذن مسبق من دايرة الحكومة الذكية أو الهيئات الحكومية التي تمثلها تلك العلامات التجارية',
    },
  ]
};

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
