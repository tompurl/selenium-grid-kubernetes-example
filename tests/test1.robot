*** Settings ***
Documentation               Visit whatsmybrowser.org and ensure that it's checking for your Flash Version
...
Library                     SeleniumLibrary
Test Setup                  Start browser
Test Teardown               Close All Browsers

*** Keywords ***
Start Browser
    [Documentation]         Start browser on Selenium Grid
    Open Browser            ${URL}  ${BROWSER}  ${ALIAS}  ${REMOTE_URL}  ${DESIRED_CAPABILITIES}
    Maximize Browser Window

*** Test Cases ***
Capture screenshot of whatsmybrowser.org and ensure that it is checking for flash
    Log Variables
    Capture Page Screenshot
    Sleep   10
    Wait Until Page Contains    Flash version