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
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone


private const val ACTION_SCHEDULED_UPDATE = "live.iqfareez.waktusolatmalaysia.SCHEDULED_UPDATE"

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
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
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
            val ids = manager.getAppWidgetIds(ComponentName(context, SolatHorizontalWidget::class.java))
            onUpdate(context, manager, ids)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    widgetData: SharedPreferences
) {
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.solat_horizontal_widget)

    val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
    val pendingIntent = PendingIntent.getActivity(
        context, 0, launchIntent,
        PendingIntent.FLAG_IMMUTABLE
    )

    // Set the click listener for the widget
    views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

    val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
    dateFormat.timeZone = TimeZone.getTimeZone("Asia/Kuala_Lumpur") // Set Malaysia timezone
    val formattedDate = dateFormat.format(Date())

    views.setTextViewText(R.id.widget_date, formattedDate)

    //  Set widget content
    views.setTextViewText(
        R.id.widget_title, widgetData.getString("widget_title", null)
            ?: "Please open app to set widget data"
    )
    views.setTextViewText(
        R.id.subuh_time, widgetData.getString("widget_subuh_time", null)
            ?: "00:00"
    )
    views.setTextViewText(
        R.id.zuhur_time, widgetData.getString("widget_zuhur_time", null)
            ?: "00:00"
    )
    views.setTextViewText(
        R.id.asar_time, widgetData.getString("widget_asar_time", null)
            ?: "00:00"
    )
    views.setTextViewText(
        R.id.maghrib_time, widgetData.getString("widget_maghrib_time", null)
            ?: "00:00"
    )
    views.setTextViewText(
        R.id.isyak_time, widgetData.getString("widget_isyak_time", null)
            ?: "00:00"
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