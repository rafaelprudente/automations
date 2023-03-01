*** Settings ***
Library     RPA.Browser.Selenium
Library     String
Library     RPA.Excel.Files
Library     RPA.FileSystem
Library     Collections
Library     RPA.Tables
Library     MyFunctions


*** Variables ***
@{SECTIONS_LIST}
...    A
...    B
...    C
...    D
...    E
...    F
...    G
...    H
...    I
...    J
...    K
...    L
...    M
...    N
...    O
...    P
...    Q
...    R
...    S
...    T
...    U
...    V
...    W
...    X
...    Y
...    Z
${SECTION_INDEX}
${SECTION_LABEL}
${QTD_FIIS_TXT}
${QTD_FIIS}
@{FIIS_LIST}
${FIIS_CODE}
${fiiCode}
${fiiDescription}
${dividendYield}


*** Tasks ***
Get Fiis Info
	Open browser
	Get fiis quantity
 	Get fiis codes

    Remove File    %{ROBOT_ROOT}${/}informacoes_fiis.xlsx
    
    Log To Console    .
    FOR    ${FIIS_CODE}    IN    @{FIIS_LIST}
        Log To Console    ${FIIS_CODE}

        ${fiiUrl}=    Catenate    SEPARATOR=    https://fiis.com.br/    ${FIIS_CODE}    /
        Go To    ${fiiUrl}
        ${fiiCode}=    Get Text    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[1]/h1
        
        ${fiiDescription}=    Get Text    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[1]/p
        
        ${dividendYield}=    Get Text
        ...    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[2]/div/div[1]/p[1]/b
        ${dividendYieldNumber}=    Br Currency To Number    ${dividendYield}

        ${ultimoRendimento}=    Get Text
        ...    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[2]/div/div[2]/p[1]/b
        ${ultimoRendimentoNumber}=    Br Currency To Number    ${ultimoRendimento}

        ${patrimonioLiquido}=    Get Text
        ...    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[2]/div/div[3]/p[1]/b
        ${patrimonioLiquidoNumber}=    Patrimonio Liquido To Number    ${patrimonioLiquido}    

        ${pVp}=    Get Text    xpath=//*[@id='carbon_fields_fiis_header-2']/div/div/div[1]/div[2]/div/div[4]/p[1]/b
        ${pVpNumber}=    Br Currency To Number    ${pVp}

        ${fileNotExist}=    Does File Not Exist    %{ROBOT_ROOT}${/}informacoes_fiis.xlsx
        &{newRow}=    Create Dictionary
        ...    Código=${fiiCode}
        ...    Descrição=${fiiDescription}
        ...    Dividend Yield=${dividendYieldNumber}
        ...    Último Rendimento=${ultimoRendimentoNumber}
        ...    Patrimônio Líquido=${patrimonioLiquidoNumber}
        ...    P/VP=${pVpNumber}
        IF    ${filenotexist}
            Create Workbook    %{ROBOT_ROOT}${/}informacoes_fiis.xlsx    xlsx
            @{worksheetData}=    Create List    ${newRow}
            Create Worksheet    FIIs    ${worksheetData}    header=True
        ELSE
            Open Workbook    %{ROBOT_ROOT}${/}informacoes_fiis.xlsx
            Append Rows To Worksheet    ${newRow}
        END
        Save Workbook
    END
    [Teardown]    Close Browser


*** Keywords ***
Open browser
    Open Available Browser    https://fiis.com.br/lista-de-fundos-imobiliarios/    headless=${TRUE}
    Sleep    3s

    
Get fiis quantity
    ${QTD_FIIS_TXT}=    Get Text    alias:SearchTickerfound
    ${QTD_FIIS_TXT}=    Remove String    ${QTD_FIIS_TXT}    fiis
    ${QTD_FIIS}=    Convert To Number    ${QTD_FIIS_TXT}


Get fiis codes
    FOR    ${SECTION_INDEX}    IN    @{SECTIONS_LIST}
        ${SECTION_LABEL}=    Catenate    SEPARATOR=    letter-id-    ${SECTION_INDEX}
        FOR    ${INDEX_FIIS}    IN RANGE    1    1000
            ${contains}=    Does Page Contain Element
            ...    xpath=//*[@id='${SECTION_LABEL}']/div[1]/div[${INDEX_FIIS}]/a/div
            IF    ${contains}
                ${FIIS_CODE}=    Get Text    xpath=//*[@id='${SECTION_LABEL}']/div[1]/div[${INDEX_FIIS}]/a/div
                Append To List    ${FIIS_LIST}    ${FIIS_CODE}
                Log To Console    .    no_newline=${TRUE}
            ELSE
                BREAK
            END
        END
    END
    Log To Console    .
