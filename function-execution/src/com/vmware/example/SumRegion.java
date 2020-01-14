package com.vmware.example;

import org.apache.geode.cache.Region;
import org.apache.geode.cache.execute.FunctionAdapter;
import org.apache.geode.cache.execute.FunctionContext;
import org.apache.geode.cache.execute.RegionFunctionContext;

import java.util.Map;
import java.util.Set;

public class SumRegion extends FunctionAdapter {

    public void execute(FunctionContext fc) {
        RegionFunctionContext regionFunctionContext = (RegionFunctionContext) fc;
        Region<Object, Object> dataSet = regionFunctionContext.getDataSet();

        Set<Map.Entry<Object, Object>> entries = dataSet.entrySet();

        Double sum = 0.0;
        for(Map.Entry<Object, Object> entry : entries) {
            sum += (Double) entry.getValue();
        }

        fc.getResultSender().lastResult(sum);
    }

    public String getId() {
        return getClass().getName();
    }
}
