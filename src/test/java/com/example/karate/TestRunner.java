package com.example.karate;

import com.intuit.karate.junit5.Karate;

public class TestRunner {
    
    @Karate.Test
    Karate testSample() {
        return Karate.run("classpath:sample-api-test.feature");
    }
    
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:").relativeTo(getClass());
    }
}