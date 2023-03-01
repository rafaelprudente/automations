*** Settings ***
Library     RPA.Browser.Selenium
Library     RPA.FileSystem
Library     DateTime


*** Tasks ***
Obter Valor Cotação Euro
    [Documentation]    Obter valor cotação euro.
    Open Available Browser
    ...    https://www.google.com/search?q=Cota%C3%A7%C3%A3o+euro+real+brasileiro&newwindow=1&rlz=1C5CHFA_enBR1004BR1004&sxsrf=AJOqlzVWhip2IUho70hwHh2Y5r6cIbZDiQ%3A1675813778582&ei=kuPiY7qII6mF9u8PtNetUA&ved=0ahUKEwi6me3nzIT9AhWpgv0HHbRrCwoQ4dUDCA8&uact=5&oq=Cota%C3%A7%C3%A3o+euro+real+brasileiro&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAzIKCAAQgAQQRhCCAjIGCAAQFhAeMgsIABAWEB4Q8QQQCjIGCAAQFhAeMgYIABAWEB4yCQgAEBYQHhDxBDIJCAAQFhAeEPEEMgkIABAWEB4Q8QQyCQgAEBYQHhDxBDoKCAAQRxDWBBCwAzoHCAAQsAMQQzoSCC4QxwEQ0QMQyAMQsAMQQxgBOgQIIxAnOgQIABBDOgYIABAHEB46CQgAEAcQHhDxBDoHCAAQDRCABDoJCCMQJxBGEIICOgUIABCABDoJCAAQQxBGEIICSgQIQRgASgQIRhgAUOgHWJguYI4yaAJwAXgAgAGCAYgBgxCSAQQwLjE4mAEAoAEByAEMwAEB2gEECAEYCA&sclient=gws-wiz-serp
    Click Element When Visible    alias:ButtonidW0wltcdiv
    ${valor-cotacao}=    Get Element Attribute
    ...    alias:Idknowledgecurrencyupdatabledatacolumndiv1div2span1
    ...    data-value
    ${fileNotExist}=    Does File Not Exist    %{ROBOT_ROOT}${/}results${/}cotacoes.txt
    ${currentDateTime}=    Get Current Date    exclude_millis=${TRUE}
    IF    $filenotexist
        Create File    %{ROBOT_ROOT}${/}results/cotacoes.txt    data;value\n    overwrite=${FALSE}
    END
    Append To File    %{ROBOT_ROOT}${/}results/cotacoes.txt    ${currentDateTime}
    Append To File    %{ROBOT_ROOT}${/}results/cotacoes.txt    ;
    Append To File    %{ROBOT_ROOT}${/}results/cotacoes.txt    ${valor-cotacao}
    Append To File    %{ROBOT_ROOT}${/}results${/}cotacoes.txt    \n
    [Teardown]    Close All Browsers
