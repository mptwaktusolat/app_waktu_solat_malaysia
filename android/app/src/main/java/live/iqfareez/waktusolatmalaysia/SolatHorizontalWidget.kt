package live.iqfareez.waktusolatmalaysia

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone


private const val ACTION_SCHEDULED_UPDATE = "live.iqfareez.waktusolatmalaysia.SCHEDULED_UPDATE"
private const val LOG_TAG = "MPT_Widget_Horizontal"

/**
 * Implementation of App Widget functionality.
 */
class SolatHorizontalWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            Log.i(LOG_TAG, "onUpdate: SolatHorizontalWidget called")
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData, R.layout.solat_horizontal_widget)
        }

        scheduleNextUpdate(context);
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent);
        if (intent.action.equals(ACTION_SCHEDULED_UPDATE)) {
            val manager = AppWidgetManager.getInstance(context)
            val ids =
                manager.getAppWidgetIds(ComponentName(context, SolatHorizontalWidget::class.java))
            onUpdate(context, manager, ids)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    widgetData: SharedPreferences,
    layoutId: Int
) {
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, layoutId)

    val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
    val pendingIntent = PendingIntent.getActivity(
        context, 0, launchIntent,
        PendingIntent.FLAG_IMMUTABLE
    )

    // Set the click listener for the widget
    views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

    // Parse the JSON in SharedPreferences
    val prayerData = widgetData.getString("prayer_data", null);

    // If data not available, display help message
    if (prayerData == null) {
        views.setTextViewText(R.id.widget_date, "Please open app to get prayer data")
        return;
    }

    val parsed = JSONObject(prayerData)

    Log.i(LOG_TAG, "updateAppWidget: Reading SP json ${parsed.get("zone")}, ${parsed.get("month")}-${parsed.get("year")} ")

    val prayers = parsed.getJSONArray("prayers")

    val calendar = Calendar.getInstance()
    val todayIndex = calendar.get(Calendar.DAY_OF_WEEK) - 1;
    val todayPrayer: JSONObject = prayers.get(todayIndex) as JSONObject;

    val subuhTime = todayPrayer.getLong("fajr")
    val zohorTime = todayPrayer.getLong("dhuhr")
    val asarTime = todayPrayer.getLong("asr")
    val maghribTime = todayPrayer.getLong("maghrib")
    val isyakTime = todayPrayer.getLong("isha")

    val gmt8TimeZone = TimeZone.getTimeZone("GMT+8")
    val timeFormat = SimpleDateFormat("h:mm a")
    timeFormat.timeZone = gmt8TimeZone

    fun formatTime(timeInMillis: Long): String {
        val date = Date(timeInMillis)
        return timeFormat.format(date)
    }

    val formattedSubuhTime = formatTime(subuhTime)
    val formattedZohorTime = formatTime(zohorTime)
    val formattedAsarTime = formatTime(asarTime)
    val formattedMaghribTime = formatTime(maghribTime)
    val formattedIsyakTime = formatTime(isyakTime)

    val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
    dateFormat.timeZone = TimeZone.getTimeZone("Asia/Kuala_Lumpur") // Set Malaysia timezone
    val formattedDate = dateFormat.format(Date())

    val widgetTitle = "${parsed.get("zone")}: ${widgetData.getString("widget_title", null)}"

    //  Set content
    views.setTextViewText(R.id.widget_date, formattedDate)

    views.setTextViewText(
        R.id.widget_title, widgetTitle
            ?: "Please open app to set widget data"
    )
    views.setTextViewText(
        R.id.subuh_time, formattedSubuhTime
    )
    views.setTextViewText(
        R.id.zuhur_time, formattedZohorTime
    )
    views.setTextViewText(
        R.id.asar_time, formattedAsarTime
    )
    views.setTextViewText(
        R.id.maghrib_time, formattedMaghribTime
    )
    views.setTextViewText(
        R.id.isyak_time, formattedIsyakTime
    )

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}

// Credit to: https://stackoverflow.com/a/37901697/13617136
private fun scheduleNextUpdate(context: Context) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    // Substitute AppWidget for whatever you named your AppWidgetProvider subclass
    val intent = Intent(context, SolatHorizontalWidget::class.java)
    intent.setAction(ACTION_SCHEDULED_UPDATE)
    val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)

    // Get a calendar instance for midnight tomorrow.
    val midnight: Calendar = Calendar.getInstance()
    midnight.set(Calendar.HOUR_OF_DAY, 0)
    midnight.set(Calendar.MINUTE, 0)
    // Schedule one second after midnight, to be sure we are in the right day next time this
    // method is called.  Otherwise, we risk calling onUpdate multiple times within a few
    // milliseconds
    midnight.set(Calendar.SECOND, 1)
    midnight.set(Calendar.MILLISECOND, 0)
    midnight.add(Calendar.DAY_OF_YEAR, 1)

    // For API 19 and later, set may fire the intent a little later to save battery,
    // setExact ensures the intent goes off exactly at midnight.
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
        alarmManager[AlarmManager.RTC_WAKEUP, midnight.getTimeInMillis()] = pendingIntent
    } else {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (alarmManager.canScheduleExactAlarms()) {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    midnight.timeInMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    midnight.timeInMillis,
                    pendingIntent
                )
            }
        }
    }
}