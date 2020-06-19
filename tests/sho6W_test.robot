*** Settings ***
Documentation               Robot Framework Example
...
Library                     SeleniumLibrary
Test Setup                  Start browser
Test Teardown               Close All Browsers


*** Variables ***
${URL}                      https://www.tompurl.com
${BROWSER}                  opera
${ALIAS}                    None
${REMOTE_URL}               http://david:4444/wd/hub
${ENABLE_VIDEO}             ${True}
&{DESIRED_CAPABILITIES}     browserName=${BROWSER}    version=68.0    enableVNC=${True}    enableVideo=${ENABLE_VIDEO}


*** Keywords ***
Start Browser
    [Documentation]         Start browser on Selenium Grid
    Open Browser            ${URL}  ${BROWSER}  ${ALIAS}  ${REMOTE_URL}  ${DESIRED_CAPABILITIES}
    Maximize Browser Window

*** Test Cases ***
Test Google
    [Documentation]         Test Google
    Capture Page Screenshot
    Sleep   15
    Wait Until Page Contains    Datsun