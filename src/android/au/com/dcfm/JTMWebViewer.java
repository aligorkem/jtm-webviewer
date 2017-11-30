/**
 */
package au.com.dcfm;


import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.content.res.Configuration;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.DisplayMetrics;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import org.apache.cordova.PluginResult;

import android.util.Log;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.util.Date;

public class JTMWebViewer extends CordovaPlugin {

    private static final String TAG = "JTMWebViewer";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        main = new RelativeLayout(cordova.getActivity());
    }


    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {

        Log.d(TAG, "JTMWebViewer.execute");
        Log.d(TAG, action);

        if (action.equals("echo")) {
            String phrase = args.getString(0);
            // Echo back the first argument
            Log.d(TAG, phrase);
        } else if (action.equals("getDate")) {
            // An example of returning data back to the web layer
            final PluginResult result = new PluginResult(PluginResult.Status.OK, (new Date()).toString());
            callbackContext.sendPluginResult(result);

        } else if (action.equals("show")) {

            String optionsStr = args.getString(0);
            JSONObject options = null;

            try {

                options = new JSONObject(optionsStr);

            } catch (Throwable t) {
                Log.e("JTM", "Could not parse malformed JSON: \"" + optionsStr + "\"");
            }

            show(options);

            // An example of returning data back to the web layer
            final PluginResult result = new PluginResult(PluginResult.Status.OK, (new Date()).toString());
            callbackContext.sendPluginResult(result);
        } else if (action.equals("hide")) {

            hide();

            // An example of returning data back to the web layer
            final PluginResult result = new PluginResult(PluginResult.Status.OK, (new Date()).toString());
            callbackContext.sendPluginResult(result);
        }
        return true;
    }


    protected ViewGroup root; // original Cordova layout
    protected RelativeLayout main; // new layout to support map
    protected WebView techView;
    protected WebView syncView;
    private CallbackContext cCtx;

    public void hide() {

        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {

                if( techView != null ){
                    techView.setVisibility(View.INVISIBLE);
                }

            }
        });


    }




    private String _url = "";
    private String _urlSync = "";
    private int _bottomMargin = 0;
    private int _topMargin = 0;
    private String _userId = "";
    private String _password = "";


    public void show(final JSONObject options) {
        try {

            if( options != null ){

                _url = options.getString("url");
                _urlSync = options.getString("urlSync");
                _userId = options.getString("userId");
                _password = options.getString("password");
                _bottomMargin = options.getInt("bottomMarginAndroid");
                _topMargin = options.getInt("topMargin");

            }

            cordova.getActivity().runOnUiThread(new Runnable() {
                @SuppressLint("JavascriptInterface")
                @RequiresApi(api = Build.VERSION_CODES.KITKAT)
                @Override
                public void run() {

                    if (techView == null) {

                        double latitude = 0, longitude = 0;
                        //int height = 760;
                        boolean atBottom = false;

                        DisplayMetrics displayMetrics = new DisplayMetrics();
                        cordova.getActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
                        int width = displayMetrics.widthPixels;
                        int height = displayMetrics.heightPixels;


                        techView = new WebView(cordova.getActivity());
                        syncView = new WebView(cordova.getActivity());

                        techView.setWebViewClient(new WebViewClient());
                        techView.getSettings().setJavaScriptEnabled(true);
                        techView.getSettings().setDatabaseEnabled(true);
                        techView.getSettings().setDomStorageEnabled(true);

                        techView.addJavascriptInterface(new JsInterface(main.getContext(), techView, syncView, _userId, _password), "JTMAndroid");


                        techView.loadUrl(_url);

                        FrameLayout layout = (FrameLayout) webView.getView().getParent();

                        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(width, height - _bottomMargin);
                        params.setMargins(0, 0, 0, 0);
                        techView.setLayoutParams(params);
                        layout.addView(techView);

                        //syncView
                        syncView.setWebViewClient(new WebViewClient());
                        syncView.getSettings().setJavaScriptEnabled(true);
                        syncView.getSettings().setDatabaseEnabled(true);
                        syncView.getSettings().setDomStorageEnabled(true);

                        syncView.addJavascriptInterface(new JsInterface(main.getContext(), techView, syncView, _userId, _password), "JTMAndroid");

                        syncView.loadUrl(_urlSync);

                        FrameLayout.LayoutParams syncParams = new FrameLayout.LayoutParams(1, 1);
                        syncParams.setMargins(0, 50, 0, 0);
                        syncView.setLayoutParams(syncParams);

                        techView.addView(syncView);


                    } else {
                        techView.setVisibility(View.VISIBLE);
                    }


                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            cCtx.error("MapKitPlugin::showMap(): An exception occured");
        }


    }


    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        DisplayMetrics displayMetrics = new DisplayMetrics();
        cordova.getActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        int width = displayMetrics.widthPixels;
        int height = displayMetrics.heightPixels;


        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(width, height - 200);
        params.setMargins(0, 0, 0, 0);
        techView.setLayoutParams(params);


        // Checks the orientation of the screen
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {

        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT){

        }
    }


}