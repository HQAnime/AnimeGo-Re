package com.yihengquan.gogoanime;

import android.app.Application;
import com.reactnativenavigation.NavigationApplication;
import com.facebook.react.ReactPackage;

import com.oblador.vectoricons.VectorIconsPackage;

import java.util.Arrays;
import java.util.List;

public class MainApplication extends NavigationApplication {
    @Override
    public boolean isDebug() {
        return BuildConfig.DEBUG;
    }

    protected List<ReactPackage> getPackages() {
        // Add additional packages you require here
        // No need to add RnnPackage and MainReactPackage
        return Arrays.<ReactPackage>asList(
            new VectorIconsPackage()
        );
    }
    
    @Override
     public List<ReactPackage> createAdditionalReactPackages() {
         return getPackages();
     }

    @Override
    public String getJSMainModuleName() {
        return "index";
    }
}