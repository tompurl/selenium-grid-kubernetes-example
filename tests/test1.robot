*** Settings ***
Documentation               Robot Framework Example
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
Test Google
    [Documentation]         Test Google
    Log Variables
    Capture Page Screenshot
    Sleep   15
    Wait Until Page Contains    Datsun