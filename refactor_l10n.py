import os, re, json

translations = [
    ("SmartPark JORDAN", "smartParkJordan", "سمارت بارك الأردن"),
        ("Parking Name", "ParkingName", "اسم الكراج"),

    ("Find. Reserve. Park Smart.", "findReserveParkSmart", "ابحث. احجز. أوقف بذكاء."),
    ("Thank you for your rating!", "thankYouForRating", "شكراً لتقييمك!"),
    ("Pick parking location", "pickParkingLocation", "اختر موقع الموقف"),
    ("Select parking spot", "selectParkingSpot", "اختر المكان"),
    ("N/A", "na", "غير متوفر"),
    ("Please select a parking spot!", "pleaseSelectParkingSpot", "يرجى اختيار موقف!"),
    ("OK", "ok", "حسناً"),
    ("Rate Your Experience", "rateYourExperience", "قيّم تجربتك"),
    ("Cancel", "cancel", "إلغاء"),
    ("Earnings", "earnings", "الأرباح"),
    ("Support", "support", "الدعم"),
    ("Welcome Driver", "welcomeDriver", "مرحباً أيها السائق"),
    ("Parking Added Successfully", "parkingAddedSuccessfully", "تم إضافة الموقف بنجاح"),
    ("Add Parking Lot", "addParkingLot", "إضافة موقف سيارات"),
    ("Something went wrong", "somethingWentWrong", "حدث خطأ ما"),
    ("Failed to update, try again.", "failedToUpdateTryAgain", "فشل التحديث، يرجى المحاولة مرة أخرى."),
    ("Choose Available Spot", "chooseAvailableSpot", "اختر مكاناً متاحاً"),
    ("My Booking", "myBooking", "حجوزاتي"),
    ("No reservation found.", "noReservationFound", "لا يوجد حجز."),
    ("You don't have enough money to make a reservation!", "notEnoughMoney", "رصيدك غير كافٍ لإجراء الحجز!"),
    ("Update", "update", "تحديث"),
    ("No past reservations.", "noPastReservations", "لا توجد حجوزات سابقة."),
    ("No user logged in!", "noUserLoggedInError", "لم يتم تسجيل الدخول!"),
    ("Are you sure you want to log out?", "confirmLogOut", "هل أنت متأكد من تسجيل الخروج؟"),
    ("Reserve Spot", "reserveSpot", "احجز موقفاً"),
    ("Price per hour", "pricePerHour", "السعر بالساعة"),
    ("You have already rated this parking!", "alreadyRated", "لقد قمت بتقييم هذا الموقف مسبقاً!"),
    ("Delete", "delete", "حذف"),
    ("Thank you for reaching out!", "thankYouForReachingOut", "شكراً لتواصلك معنا!"),
    ("Total This Month", "totalThisMonth", "الإجمالي هذا الشهر"),
    ("Are you sure you want to delete this parking lot?", "confirmDeleteParking", "هل أنت متأكد من حذف هذا الموقف؟"),
    ("Privacy & Security", "privacySecurity", "الخصوصية والأمان"),
    ("Password", "password", "كلمة المرور"),
    ("AI Chat Bot", "aiChatBot", "المساعد الذكي"),
    ("Edit", "edit", "تعديل"),
    ("Phone Number", "phoneNumber", "رقم الهاتف"),
    ("Please fill all required fields", "fillRequiredFields", "يرجى ملء جميع الحقول المطلوبة"),
    ("My Information", "myInformation", "معلوماتي"),
    ("You must be logged in!", "mustBeLoggedIn", "يجب تسجيل الدخول!"),
    ("Summary", "summary", "ملخص"),
    ("Invalid Input", "invalidInput", "إدخال غير صالح"),
    ("Owner Dashboard", "ownerDashboard", "لوحة تحكم المُلاك"),
    ("Confirm Location", "confirmLocation", "تأكيد الموقع"),
    ("Log out of your account", "logOutAccount", "تسجيل الخروج من حسابك"),
    ("No parking lots added yet.", "noParkingLotsYet", "لم تتم إضافة مواقف بعد."),
    ("Your Message", "yourMessage", "رسالتك"),
    ("Confirm reservation", "confirmReservation", "تأكيد الحجز"),
    ("Register", "register", "تسجيل"),
    ("Select Payment Type", "selectPaymentType", "اختر طريقة الدفع"),
    ("Active Reservation", "activeReservation", "حجز نشط"),
    ("Need Help?", "needHelp", "تحتاج للمساعدة؟"),
    ("Login", "login", "تسجيل الدخول"),
    ("Profile", "profile", "الملف الشخصي"),
    ("Park with a Smile 😊", "parkWithSmile", "أوقف سيارتك بابتسامة 😊"),
    ("Type a message...", "typeMessage", "اكتب رسالة..."),
    ("Leave a comment (optional)", "leaveComment", "اترك تعليقاً (اختياري)"),
    ("Add Parking", "addParking", "إضافة موقف"),
    ("My Parking Lots", "myParkingLots", "مواقفي"),
    ("Manage", "manage", "إدارة"),
    ("Your Control", "yourControl", "لوحة التحكم"),
    ("Time Elapsed", "timeElapsed", "الوقت المنقضي"),
    ("Save Changes", "saveChanges", "حفظ التغييرات"),
    ("Settings", "settings", "الإعدادات"),
    ("Updated successfully!", "updatedSuccessfully", "تم التحديث بنجاح!"),
    ("Parking updated successfully!", "parkingUpdatedSuccessfully", "تم تحديث الموقف بنجاح!"),
    ("No available spots", "noAvailableSpots", "لا تتوفر أماكن"),
    ("Remove Card", "removeCard", "حذف البطاقة"),
    ("Parking lot deleted successfully!", "parkingDeletedSuccessfully", "تم حذف الموقف بنجاح!"),
    ("Your Privacy Matters", "privacyMatters", "خصوصيتك تهمنا"),
    ("Add Payment Method", "addPaymentMethod", "إضافة طريقة دفع"),
    ("Confirm Spot", "confirmSpot", "تأكيد الموقف"),
    ("Enter your Password", "enterPassword", "أدخل كلمة المرور"),
    ("Rating submitted successfully!", "ratingSubmittedSuccess", "تم تقديم التقييم بنجاح!"),
    ("No spots available", "noSpotsAvailable", "لا تتوفر أماكن"),
    ("Please select a rating", "pleaseSelectRating", "يرجى اختيار تقييم"),
    ("Pick", "pick", "اختر"),
    ("Confirm Parking Spot", "confirmParkingSpot", "تأكيد مكان الوقوف"),
    ("Confirm Delete", "confirmDelete", "تأكيد الحذف"),
    ("Send Message", "sendMessage", "إرسال رسالة"),
    ("Your message has been sent to the Help Center!", "messageSentHelpCenter", "تم إرسال رسالتك إلى مركز المساعدة!"),
    ("Let’s Park!", "letsPark", "فلنركن!"),
    ("Edit Parking", "editParking", "تعديل الموقف"),
    ("No parking lots found", "noParkingLotsFound", "لم يتم العثور على مواقف"),
    ("No user logged in", "noUserSet", "لم يتم تسجيل الدخول"),
    ("Search by location or name...", "searchLocationName", "البحث حسب الموقع أو الاسم..."),
    ("Welcome Owner", "welcomeOwner", "مرحباً أيها المالك"),
    ("Confirm", "confirm", "تأكيد"),
    ("No upcoming reservations.", "noUpcomingReservations", "لا توجد حجوزات قادمة."),
    ("Manage Spots", "manageSpots", "إدارة الأماكن"),
    ("Help Center", "helpCenter", "مركز المساعدة"),
    ("No data found", "noDataFound", "لا توجد بيانات"),
    ("User Information", "userInformation", "معلومات المستخدم"),
    ("Submit", "submit", "إرسال"),
    ("Pick Location", "pickLocation", "اختيار الموقع"),
    ("Log Out", "logOut", "تسجيل الخروج"),
    ("Card removed successfully. You can add a new one now.", "cardRemovedSuccessfully", "تم حذف البطاقة بنجاح. يمكنك إضافة بطاقة جديدة الآن."),
    ("You already have a card! Remove it first to add a new one.", "alreadyHaveCard", "لديك بطاقة بالفعل! قم بإزالتها أولاً لإضافة واحدة جديدة."),
    ("You can update or delete your personal information at any time from your profile settings. ", "updatePrivacySettings", "يمكنك تحديث أو حذف معلوماتك الشخصية في أي وقت من إعدادات ملفك الشخصي."),
    ("We are committed to protecting your personal information and ensuring transparency about how we collect, use, and store it. ", "privacyPolicy1", "نحن ملتزمون بحماية معلوماتك الشخصية وضمان الشفافية حول كيفية جمعها واستخدامها وتخزينها."),
    ("For more details, contact our support team or review our full privacy policy in the app settings.", "privacyPolicy2", "لمزيد من التفاصيل، تواصل مع فريق الدعم أو راجع سياسة الخصوصية بالكامل في الإعدادات."),
    ("Tell us what’s going on, and we’ll get back to you as soon as possible.", "tellUsWhatsGoingOn", "أخبرنا بما يحدث وسنرد عليك في أقرب وقت ممكن.")
]

en_arb = {}
ar_arb = {}
for eng, key, ar in translations:
    en_arb[key] = eng
    ar_arb[key] = ar

os.makedirs('lib/l10n', exist_ok=True)
with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en_arb, f, indent=2, ensure_ascii=False)
with open('lib/l10n/app_ar.arb', 'w', encoding='utf-8') as f:
    json.dump(ar_arb, f, indent=2, ensure_ascii=False)

def apply():
    with open('strings_output.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    files_to_update = data['files']
    
    for file_path in files_to_update:
        if not os.path.exists(file_path): continue
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        orig_content = content
        
        # We need to prepend import for AppLocalizations if there are translations used
        # We'll check if any string matches
        
        for eng, key, ar in translations:
            # We are assuming exact matches for hardcoded
            # For `Text('Eng')` -> Text(AppLocalizations.of(context)!.key)
            # Handle double quotes and single quotes
            
            # Simple string match replacing
            # Regex to find exactly 'eng' or "eng" inside Text() or hintText:
            pattern1 = r'Text\(\s*(["\'])' + re.escape(eng) + r'\1'
            content = re.sub(pattern1, r'Text(AppLocalizations.of(context)!.' + key, content)
            
            pattern2 = r'(hintText|labelText):\s*(["\'])' + re.escape(eng) + r'\2'
            content = re.sub(pattern2, r'\1: AppLocalizations.of(context)!.' + key, content)
            
            # General generic match for widgets
            pattern3 = r'title:\s*Text\(\s*(["\'])' + re.escape(eng) + r'\1'
            content = re.sub(pattern3, r'title: Text(AppLocalizations.of(context)!.' + key, content)
            
            # SnackBar, etc
            pattern4 = r'SnackBar\(content:\s*Text\(\s*(["\'])' + re.escape(eng) + r'\1'
            content = re.sub(pattern4, r'SnackBar(content: Text(AppLocalizations.of(context)!.' + key, content)

            # direct strings used inside other arguments, let's keep it careful
            
        # Also remove exact Arabic strings already in code to avoid duplication
        # "ابحث. احجز. أوقف بذكاء."
        content = re.sub(r'const\s+Text\(\s*["\']ابحث. احجز. أوقف بذكاء.["\'].*?\),?', '', content, flags=re.DOTALL)
        content = re.sub(r'const\s+Text\(\s*["\']مرحباً أيها السائق 👋["\'].*?\),?', '', content, flags=re.DOTALL)
        content = re.sub(r'const\s+Text\(\s*["\']مرحباً أيها المالك 👋["\'].*?\),?', '', content, flags=re.DOTALL)

        # Remove trailing/leading const where Text(...) was const but AppLocalizations context makes it non-const
        content = re.sub(r'const\s+Text\(AppLocalizations', r'Text(AppLocalizations', content)
        content = re.sub(r'const\s+Padding\(\s*padding:\s*.*?,?\s*child:\s*Text\(AppLocalizations', r'Padding(padding: EdgeInsets.zero, child: Text(AppLocalizations', content)

        # It's better to just regex away const for Text widgets wrapper that now use context
        # But this can be too aggressive, let's just strip 'const ' before Text(AppLocalizations
        content = re.sub(r'const\s+Text\(AppLocalizations', r'Text(AppLocalizations', content)

        # RTL direction optimizations
        content = re.sub(r'EdgeInsets\.only\(\s*left:\s*([^,)]+),\s*right:\s*([^,)]+)\)', r'EdgeInsetsDirectional.only(start: \1, end: \2)', content)
        content = re.sub(r'EdgeInsets\.only\(\s*right:\s*([^,)]+),\s*left:\s*([^,)]+)\)', r'EdgeInsetsDirectional.only(end: \1, start: \2)', content)
        content = re.sub(r'EdgeInsets\.only\(\s*left:\s*([^,)]+)\)', r'EdgeInsetsDirectional.only(start: \1)', content)
        content = re.sub(r'EdgeInsets\.only\(\s*right:\s*([^,)]+)\)', r'EdgeInsetsDirectional.only(end: \1)', content)
        
        content = content.replace('Alignment.topLeft', 'AlignmentDirectional.topStart')
        content = content.replace('Alignment.topRight', 'AlignmentDirectional.topEnd')
        content = content.replace('Alignment.bottomLeft', 'AlignmentDirectional.bottomStart')
        content = content.replace('Alignment.bottomRight', 'AlignmentDirectional.bottomEnd')

        # Add import if there were changes involving AppLocalizations
        if 'AppLocalizations' in content and 'flutter_gen/gen_l10n/app_localizations.dart' not in content:
            # find first import
            content = "import 'package:flutter_gen/gen_l10n/app_localizations.dart';\n" + content
            
        if orig_content != content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Updated {file_path}")

if __name__ == '__main__':
    apply()
