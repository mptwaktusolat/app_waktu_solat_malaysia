package live.iqfareez.waktusolatmalaysia

import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import es.antonborri.home_widget.HomeWidgetPlugin
import live.iqfareez.waktusolatmalaysia.common.Constants
import live.iqfareez.waktusolatmalaysia.model.MptHijriDate
import live.iqfareez.waktusolatmalaysia.ui.theme.AndroidTheme
import live.iqfareez.waktusolatmalaysia.util.getWidgetSharedPreferences
import me.zhanghai.compose.preference.ProvidePreferenceTheme
import me.zhanghai.compose.preference.SwitchPreference
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone

private const val TAG = "HomeWidgetPreferencesActivity"

@OptIn(ExperimentalMaterial3Api::class)
class HomeWidgetPreferencesActivity : ComponentActivity() {
    var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set the result to CANCELED.  This will cause the widget host to cancel
        // out of the widget placement if the user presses the back button.
        // NOTE: If we put RESULT_OK here instead, it will crash on Xiaomi phone.
        setResult(RESULT_CANCELED)

        // Find the widget id from the intent.
        appWidgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        // If this activity was started with an intent without an app widget ID, finish with an error.
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        enableEdgeToEdge()
        setContent {
            AndroidTheme {
                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    topBar = {
                        TopAppBar(
                            colors = TopAppBarDefaults.topAppBarColors(
                                containerColor = MaterialTheme.colorScheme.surfaceContainer,
                                titleContentColor = MaterialTheme.colorScheme.onSurface,
                            ),
                            actions = {
                                TextButton(onClick = { finishConfiguration() }) {
                                    Text(text = stringResource(R.string.action_done))
                                }
                            },
                            title = {
                                Text(stringResource(R.string.title_activity_time_widget_settings))
                            }
                        )
                    },
                ) { innerPadding ->
                    SettingsComponent(
                        modifier = Modifier.padding(innerPadding),
                        appWidgetId = appWidgetId,
                        onHijriDatePreferenceChanged = { isHijriDateEnabled ->
                            handleHijriDatePrefChanged(isHijriDateEnabled)
                        },
                        onSyurukTimePreferenceChanged = { isSyurukTimeEnabled ->
                            handleSyurukTimePrefChanged(isSyurukTimeEnabled)
                        }
                    )
                }
            }
        }
    }

    /**
     * Update the widget date display based on the preference.
     */
    private fun handleHijriDatePrefChanged(isHijriDateEnabled: Boolean) {
        Log.d(
            TAG,
            "handlePreferenceChange: isHijriDateEnabled is $isHijriDateEnabled"
        )
        // It is the responsibility of the configuration activity to update the app widget
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val providerInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)

        // Save to SharedPreferences
        val sharedPref = this.getWidgetSharedPreferences(appWidgetId)
        with(sharedPref.edit()) {
            putBoolean(Constants.SP_HIJRI_DATE_PREFERENCE, isHijriDateEnabled)
            apply()
        }

        val remoteViews = RemoteViews(this.packageName, providerInfo.initialLayout)

        if (isHijriDateEnabled) {
            val widgetData = HomeWidgetPlugin.getData(this)
            val prayerData = widgetData.getString("prayer_data", null)
            if (prayerData == null) {
                Log.w(TAG, "handlePreferenceChange: prayerData is null. Cannot update widget.")
                return
            }
            val parsed = JSONObject(prayerData)
            val prayers = parsed.getJSONArray("prayers")

            val calendar = Calendar.getInstance()
            val todayIndex = calendar.get(Calendar.DAY_OF_MONTH) - 1
            val todayPrayer: JSONObject = prayers.get(todayIndex) as JSONObject
            val hijriDateToday = todayPrayer.getString("hijri")
            val hijriParsed = MptHijriDate.parseFromHijriString(hijriDateToday)
            remoteViews.setTextViewText(R.id.widget_date, hijriParsed.dMY())
        } else {
            val malaysiaTimeZone = TimeZone.getTimeZone("Asia/Kuala_Lumpur")
            val formattedDate = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
                .apply { timeZone = malaysiaTimeZone }
                .format(Date())
            remoteViews.setTextViewText(R.id.widget_date, formattedDate)
        }

        Log.d(TAG, "handlePreferenceChange: Now partially update widget $appWidgetId")

        // We partially update widget for performance reason. Read more on https://developer.android.com/develop/ui/views/appwidgets/advanced#update-widgets
        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, remoteViews)
    }

    /**
     * Handle the syuruk time preference
     */
    private fun handleSyurukTimePrefChanged(isSyurukTimeEnabled: Boolean) {
        Log.d(
            TAG,
            "handleSyurukTimePreferenceChanged: isSyurukTimeEnabled is $isSyurukTimeEnabled"
        )
        // It is the responsibility of the configuration activity to update the app widget
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val providerInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)

        // Save to SharedPreferences
        val sharedPref = this.getWidgetSharedPreferences(appWidgetId)
        with(sharedPref.edit()) {
            putBoolean(Constants.SP_SHOW_SYURUK_PREFERENCE, isSyurukTimeEnabled)
            apply()
        }

        val remoteViews = RemoteViews(this.packageName, providerInfo.initialLayout)

        remoteViews.setViewVisibility(
            R.id.syuruk_layout,
            if (isSyurukTimeEnabled) View.VISIBLE else View.GONE
        )

        Log.d(TAG, "handleSyurukTimePreferenceChanged: Now partially update widget $appWidgetId")

        // We partially update widget for performance reason. Read more on https://developer.android.com/develop/ui/views/appwidgets/advanced#update-widgets
        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, remoteViews)
    }

    private fun finishConfiguration() {
        // Make sure we pass back the original appWidgetId
        val resultValue = Intent()
        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        setResult(RESULT_OK, resultValue)
        finish()
    }
}

@Composable
fun SettingsComponent(
    modifier: Modifier = Modifier,
    appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID,
    onHijriDatePreferenceChanged: (Boolean) -> Unit = {},
    onSyurukTimePreferenceChanged: (Boolean) -> Unit = {},
) {
    val context = LocalContext.current
    val sharedPref = context.getWidgetSharedPreferences(appWidgetId)

    var isHijriDateEnabled by remember {
        mutableStateOf(sharedPref.getBoolean(Constants.SP_HIJRI_DATE_PREFERENCE, false))
    }

    var isSyurukTimeEnabled by remember {
        mutableStateOf(sharedPref.getBoolean(Constants.SP_SHOW_SYURUK_PREFERENCE, false))
    }

    // This composable use components from https://github.com/zhanghai/ComposePreference
    ProvidePreferenceTheme {
        Column(modifier = modifier) {
            SwitchPreference(
                title = { Text(text = stringResource(R.string.date_type_title)) },
                summary = { Text(text = stringResource(R.string.date_type_summary)) },
                value = isHijriDateEnabled,
                onValueChange = {
                    isHijriDateEnabled = it
                    onHijriDatePreferenceChanged(it)
                },
            )
            SwitchPreference(
                title = { Text(text = stringResource(R.string.syuruk_visibility_title)) },
                summary = { Text(text = stringResource(R.string.syuruk_visibility_summary)) },
                value = isSyurukTimeEnabled,
                onValueChange = {
                    isSyurukTimeEnabled = it
                    onSyurukTimePreferenceChanged(it)
                },
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun SettingsComponentPreview() {
    AndroidTheme {
        SettingsComponent()
    }
}