#!/bin/bash # ملف تخزين بيانات التذاكر TICKETS_FILE="tickets.txt" # تعريف الدوال # عرض قائمة الخيارات function show_menu() { echo "حجز تذكرة سينما" echo "=================" echo "(ا)لدخول" echo "(ع)رض الحجوزات" echo "(خ)روج" echo "=================" echo "أدخل خيارك:" read -r choice } # جمع معلومات الحجز function collect_booking_info() { echo "الاسم الأول:" read -r first_name echo "الاسم الأخير:" read -r last_name echo "اسم الفيلم:" read -r movie_name echo "التاريخ (YYYY-MM-DD):" read -r date echo "الوقت (HH:MM):" read -r time echo "رقم الصف:" read -r row echo "رقم المقعد:" read -r seat } # التحقق من صحة التاريخ والوقت function validate_date_time() { if [[ ! "<span class="math-inline">date" \=\~ ^\[0\-9\]\{4\}\-\[0\-9\]\{2\}\-\[0\-9\]\{2\}</span> ]]; then echo "التاريخ غير صحيح. يجب أن يكون بالصيغة YYYY-MM-DD." return 1 fi if [[ ! "<span class="math-inline">time" \=\~ ^\[0\-9\]\{2\}\:\[0\-9\]\{2\}</span> ]]; then echo "الوقت غير صحيح. يجب أن يكون بالصيغة HH:MM." return 1 fi return 0 } # التحقق من وجود مقعد متاح function check_seat_availability() { # قراءة جميع الحجوزات من الملف while IFS= read -r line; do booked_first_name=$(echo "<span class="math-inline">line" \| cut \-d ';' \-f 1\) booked\_last\_name\=</span>(echo "<span class="math-inline">line" \| cut \-d ';' \-f 2\) booked\_movie\_name\=</span>(echo "<span class="math-inline">line" \| cut \-d ';' \-f 3\) booked\_date\=</span>(echo "<span class="math-inline">line" \| cut \-d ';' \-f 4\) booked\_time\=</span>(echo "<span class="math-inline">line" \| cut \-d ';' \-f 5\) booked\_row\=</span>(echo "<span class="math-inline">line" \| cut \-d ';' \-f 6\) booked\_seat\=</span>(echo "$line" | cut -d ';' -f 7) # التحقق من تطابق معلومات الحجز مع معلومات الحجز الجديدة if [[ "$booked_movie_name" == "$movie_name" && "$booked_date" == "$date" && "$booked_time" == "$time" && "$booked_row" == "$row" && "$booked_seat" == "$seat" ]]; then echo "هذا المقعد محجوز بالفعل. يرجى اختيار مقعد آخر." return 1 fi done < "$TICKETS_FILE" return 0 } # حجز تذكرة function book_ticket() { # جمع معلومات الحجز collect_booking_info # التحقق من صحة التاريخ والوقت if ! validate_date_time; then return 1 fi # التحقق من وجود مقعد متاح if ! check_seat_availability; then return 1 fi # حفظ معلومات الحجز في الملف echo "$first_name;$last_name;$movie_name;$date;$time;$row;$seat" >> "$TICKETS_FILE" # إظهار رسالة تأكيد echo "تم حجز تذكرتك بنجاح!" echo "تفاصيل الحجز:" echo "الاسم الأول: $first_name" echo "الاسم الأخير: $last_name" echo "اسم الفيلم: $movie_name" echo "التاريخ: $date" echo "الوقت: $time" echo "رقم الصف: $row" echo "رقم المقعد: $seat" } # عرض الحجوزات function show_bookings() { # التحقق من وجود أي حجوزات if [ ! -s "$TICKETS_FILE" ]; then echo "لا توجد حجوزات حتى الآن." return fi # عرض جميع الحجوزات من الملف echo "قائمة الح

	