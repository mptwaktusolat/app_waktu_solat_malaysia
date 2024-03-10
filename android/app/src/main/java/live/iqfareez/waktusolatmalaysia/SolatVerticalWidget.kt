package live.iqfareez.waktusolatmalaysia

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.Calendar

private const val ACTION_SCHEDULED_UPDATE = "live.iqfareez.waktusolatmalaysia.SCHEDULED_UPDATE"
private const val LOG_TAG = "MPT_Widget_Vertical"

/**
 * Implementation of App Widget functionality.
 */
class SolatVerticalWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            Log.i(LOG_TAG, "onUpdate: SolatVerticalWidget called")
            // call from SolatHorizontalWidget
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData, R.layout.solat_vertical_widget)
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
        super.onReceive(context, intent)

        if (intent.action.equals(ACTION_SCHEDULED_UPDATE)) {
            val manager = AppWidgetManager.getInstance(context)
            val ids =
                manager.getAppWidgetIds(ComponentName(context, SolatVerticalWidget::class.java))
            onUpdate(context, manager, ids)
        }
    }
}

private fun scheduleNextUpdate(context: Context) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    // Substitute AppWidget for whatever you named your AppWidgetProvider subclass
    val intent = Intent(context, SolatVerticalWidget::class.java)
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

    // On device running Android 14 without granting SCHEDULE_EXACT_ALARM permission may crashes
    // if call the [scheduleNextUpdate] function below. See issue: https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/228
    // So, if checks below to prevent to crashes from happen by not calling the function if above two conditions
    // were met.
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (!alarmManager.canScheduleExactAlarms()) {
            // if permission was not granted, no worries, use normal set() method. But, it doesn't
            // guarantee the timing to be run exact as the time we assigned to it
            alarmManager.set(AlarmManager.RTC, midnight.timeInMillis, pendingIntent)
            Log.d(LOG_TAG, "scheduleNextUpdate: Didn't have permission-Scheduled NOT exact alarm")
        return;
        }
    }

    // When version low than Android S, no need for permission hihi, just use setExact
    // or when canScheduleExactAlarms() is true on Android S+
    // The [setExact] method was added in API Level 19. Since our minSdkVersion is not lower than 19,
    // we are safe to call this function without if checks
    alarmManager.setExact(AlarmManager.RTC, midnight.timeInMillis, pendingIntent)
    Log.d(LOG_TAG, "scheduleNextUpdate: Scheduled exact alarm")
}