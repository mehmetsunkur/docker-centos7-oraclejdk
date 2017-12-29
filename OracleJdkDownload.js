// The purpose of this is extract Oracle JDK download link whenever Oracle release new version of JDK
// and put it into jdk.url.txt file

"use strict";
var sys = require("system"),
    page = require("webpage").create(),
    logResources = false,
    url = "http://www.oracle.com/technetwork/java/javase/downloads/index.html",
    fs = require('fs'),
    extractedUrlFile = 'jdk.url.txt';
    
////////////////////////////////////////////////////////////////////////////////
phantom.onError = function (msg, trace) {
    var msgStack = ['PHANTOM ERROR: ' + msg];
    if (trace && trace.length) {
        msgStack.push('TRACE:');
        trace.forEach(function (t) {
            msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function + ')' : ''));
        });
    }
    console.log(msgStack.join('\n'));
    phantom.exit(1);
};
////////////////////////////////////////////////////////////////////////////////
console.log("### STEP 1: opening JDK page:" + url);
page.open(url, clickJDKLink);

function clickJDKLink(status) {
    if (status === 'success') {
        console.log("### STEP 2: clickJDKLink : status->" + status);
        var ua = page.evaluate(function () {
            return document.evaluate("(//td/h3[text()='JDK'])[1]/..//a", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
        });
        page.open(ua.href.toString(), JDKPageLoaded);
    } else {
        console.error("Error opening url \"" + page.reason_url + "\": " + page.reason);
        phantom.exit(1);
    }
};

function JDKPageLoaded(status) {
    if (status === 'success') {
        console.log("### STEP 3: JDKPageLoaded : status->" + status);
        page.evaluate(function () {
            var acceptRadioElement = document.evaluate("//form[text()[contains(.,'Accept')]]/input[1]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            var evnt = document.createEvent("MouseEvents");
            evnt.initEvent("click", true, true);
            acceptRadioElement.dispatchEvent(evnt);
        });
        
        var link = page.evaluate(function () {
            var downloadLink = document.evaluate("//a[contains(@href,'x64_bin.rpm')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            return downloadLink.href.toString();
        });
        console.log("### STEP 4: JDK download link extracted in file:" + extractedUrlFile + "<-"  + link);

        fs.write(extractedUrlFile, link, 'w');
    
        phantom.exit(0);
    } else {
        console.error("Error opening url \"" + page.reason_url + "\": " + page.reason);
        phantom.exit(1);
    }
};
