package live.iqfareez.waktusolatmalaysia

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class SolatHorizontalWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
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
    val pendingIntent = PendingIntent.getActivity(context, 0, launchIntent,
        PendingIntent.FLAG_IMMUTABLE)

    // Set the click listener for the widget
    views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

    // Set widget content
    views.setTextViewText(R.id.widget_title, widgetData.getString("widget_title", null)
        ?: "Please open app to set widget data")
    views.setTextViewText(R.id.subuh_time, widgetData.getString("widget_subuh_time", null)
        ?: "00:00")
    views.setTextViewText(R.id.zuhur_time, widgetData.getString("widget_zuhur_time", null)
        ?: "00:00")
    views.setTextViewText(R.id.asar_time, widgetData.getString("widget_asar_time", null)
        ?: "00:00")
    views.setTextViewText(R.id.maghrib_time, widgetData.getString("widget_maghrib_time", null)
        ?: "00:00")
    views.setTextViewText(R.id.isyak_time, widgetData.getString("widget_isyak_time", null)
        ?: "00:00")

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}