/*
 * Created by zhangxiangwei on 2020/09/11.
 * Copyright 2015－2021 Sensors Data Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.sensorsdata.analytics.abtesting.abtesting_sdk_flutter_example;

import android.app.Application;

import com.sensorsdata.abtest.OnABTestReceivedData;
import com.sensorsdata.abtest.SensorsABTest;
import com.sensorsdata.abtest.SensorsABTestConfigOptions;
import com.sensorsdata.analytics.android.sdk.SAConfigOptions;
import com.sensorsdata.analytics.android.sdk.SensorsAnalyticsAutoTrackEventType;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;

public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        SAConfigOptions configOptions = new SAConfigOptions("http://10.130.6.4:8106/sa?project=default");
        // 打开自动采集, 并指定追踪哪些 AutoTrack 事件
        configOptions.setAutoTrackEventType(SensorsAnalyticsAutoTrackEventType.APP_START |
                SensorsAnalyticsAutoTrackEventType.APP_END |
                SensorsAnalyticsAutoTrackEventType.APP_VIEW_SCREEN /*|
                SensorsAnalyticsAutoTrackEventType.APP_CLICK*/)
                .enableTrackAppCrash()
                .enableLog(true)
                .enableJavaScriptBridge(true)
                .enableVisualizedAutoTrack(true)
                .enableVisualizedAutoTrackConfirmDialog(true);
        SensorsDataAPI.startWithConfigOptions(this, configOptions);

        SensorsABTestConfigOptions abTestConfigOptions = new SensorsABTestConfigOptions("http://abtesting.saas.debugbox.sensorsdata.cn/api/v2/abtest/online/results?project-key=438B9364C98D54371751BA82F6484A1A03A5155E");
        SensorsABTest.startWithConfigOptions(this, abTestConfigOptions);
//
//
//        try {
//            SensorsABTest.shareInstance().fastFetchABTest("price", 0, new OnABTestReceivedData<Integer>() {
//                @Override
//                public void onResult(Integer result) {
//                    System.out.println("Application========" + result);
//                    // TODO 请根据 result 进行自己的试验，当前试验对照组返回值为：99，试验组依次返回：199
//                }
//            });
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}
