URL = 'https://www.whatsmybrowser.org'
BROWSER = 'chrome'
VERSION = '83.0'
ALIAS = None
REMOTE_URL = 'http://127.0.0.1:4444/wd/hub'
ENABLE_VIDEO = False
DESIRED_CAPABILITIES = {
    "browserName":BROWSER,
    "version=":VERSION,
    "enableVNC":False,
    "enableVideo":ENABLE_VIDEO,
}
