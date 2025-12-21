package live.iqfareez.waktusolatmalaysia.model

/**
 * Mpt's implementation of Hijri date
 *
 * NOTE: There is existing tool in the SDK that we can use to handle Hijri; which is the HijrahDate &
 * IslamicCalendar classes. However, the are some issues:
 * - The month names is different than what is use here (Malaysia). Eg Jamadil Akhir is written as "Jum. II"
 * - Some day are invalid to parse. Eg '1447-06-30; would throw Invalid Hijrah day of month: 30
 *
 * See also Dart implementation in: <root>\lib\shared\models\hijri_date.dart
 */
data class MptHijriDate(val day: Int, val month: Int, val year: Int) {
    val monthName: String
        get() = hijriNames[(month - 1).coerceIn(0, hijriNames.lastIndex)]

    val shortMonthName: String
        get() = shortHijriNames[(month - 1).coerceIn(0, shortHijriNames.lastIndex)]

    /**
     * Returns the date in format: "15 Ramadhan 1446"
     */
    override fun toString() = "$day $monthName $year"

    /**
     * Returns the date in format: "15 Ram. 1446"
     */
    fun dMY() = "$day ${shortMonthName}. $year"

    /**
     * Returns the date in format: "15 Ram"
     */
    fun dM() = "$day $shortMonthName"

    /**
     * Returns the date in format: "15 Ramadhan"
     */
    fun dMMM() = "$day $monthName"

    companion object {
        private val hijriNames = listOf(
            "Muharram",
            "Safar",
            "Rabiulawal",
            "Rabiulakhir",
            "Jamadilawal",
            "Jamadilakhir",
            "Rejab",
            "Syaaban",
            "Ramadhan",
            "Syawal",
            "Zulkaedah",
            "Zulhijjah"
        )

        private val shortHijriNames = listOf(
            "Muh", "Saf", "Raw", "Rak", "Jaw", "Jak", "Rej", "Syb", "Ram", "Syw", "Zkh", "Zhj"
        )

        /**
         * Parses a Hijri date string in the format "YYYY-MM-DD"
         */
        fun parseFromHijriString(hijriDate: String): MptHijriDate {
            val (y, m, d) = hijriDate.split('-')
            val year = y.toInt()
            val month = m.toInt()
            val day = d.toInt()
            return MptHijriDate(
                day = day, month = month, year = year
            )
        }
    }
}
