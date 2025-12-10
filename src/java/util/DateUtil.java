package util;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;

public final class DateUtil {

    private static final DateTimeFormatter HTML_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter VIETNAMESE_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private DateUtil() {}
    //1. Dùng để chuyển chuỗi ngày từ HTML (yyyy-MM-dd) sang java.sql.Date.
    public static Date parseHtmlDate(String dateString) {
        if (dateString == null || dateString.trim().isEmpty()) {
            return null;
        }
        try {
            LocalDate localDate = LocalDate.parse(dateString, HTML_DATE_FORMATTER);
            return Date.valueOf(localDate);
        } catch (DateTimeParseException e) {
            System.err.println("Lỗi khi chuyển đổi chuỗi ngày tháng '" + dateString + "': " + e.getMessage());
            return null;
        }
    }
//2. Dùng để chuyển java.sql.Date thành chuỗi ngày kiểu Việt Nam (dd/MM/yyyy).
    public static String formatToVietnamese(Date date) {
        if (date == null) {
            return "";
        }

        LocalDate localDate = date.toLocalDate();

        return localDate.format(VIETNAMESE_DATE_FORMATTER);
    }
    //3. Dùng để tính số đêm ở giữa hai ngày check-in và check-out

    public static long calculateNumberOfNights(Date checkIn, Date checkOut) {

        if (checkIn == null || checkOut == null || checkOut.before(checkIn) || checkOut.equals(checkIn)) {
            return 0;
        }   
        LocalDate checkInDate = checkIn.toLocalDate();
        LocalDate checkOutDate = checkOut.toLocalDate();

        return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }
}