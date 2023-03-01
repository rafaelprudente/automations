*** Settings ***
Library     RPA.Browser.Selenium
Library     RPA.Excel.Files
Library     RPA.FileSystem
Library     RPA.Tables
Library     String


*** Variables ***
${MES_DE_REFERENCIA}
${CODIGO_FIPE}
${MARCA}
${MODELO}
${ANO}
${AUTENTICACAO}
${DATA_DA_CONSULTA}
${PRECO_MEDIO}
${US_PRECO_MEDIO_ONLY_NUMBER}
${IS_GOOD_DEAL}                     'Não'
${worksheetData}


*** Tasks ***
Get Monitored Car Info
    Open Available Browser    https://veiculos.fipe.org.br    headless=${TRUE}
    Open Workbook    ${CURDIR}/input/monitoredCars.xlsx
    ${carsData}=    Read Worksheet As Table    header=True
    Close Workbook
    Remove File    %{ROBOT_ROOT}${/}result${/}informacoes_carros.xlsx
    Set Selenium Implicit Wait    10s
    Click Element When Visible    xpath=//a[@data-label='carro']
    FOR    ${carData}    IN    @{carsData}
        Click Element When Visible    xpath=//*[@id='selectMarcacarro_chosen']/a
        Click Element When Visible
        ...    xpath=//*[@id='selectMarcacarro_chosen']/div/ul/li[contains(.,'${carData}[Brand]')]
        Click Element When Visible    xpath=//*[@id='selectAnoModelocarro_chosen']/a
        Click Element When Visible
        ...    xpath=//*[@id='selectAnoModelocarro_chosen']/div/ul/li[contains(.,'${carData}[Model]')]
        Click Element When Visible    xpath=//*[@id='selectAnocarro_chosen']/a
        Click Element When Visible    xpath=//*[@id='selectAnocarro_chosen']/div/ul/li[contains(.,'${carData}[Year]')]
        Click Element When Visible    xpath=//*[@id='buttonPesquisarcarro']
        ${MES_DE_REFERENCIA}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[1]/td[2]/p
        ${CODIGO_FIPE}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[2]/td[2]/p
        ${MARCA}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[3]/td[2]/p
        ${MODELO}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[4]/td[2]/p
        ${ANO}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[5]/td[2]/p
        ${AUTENTICACAO}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[6]/td[2]/p
        ${DATA_DA_CONSULTA}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[7]/td[2]/p
        ${PRECO_MEDIO}=    Get Text    xpath=//*[@id="resultadoConsultacarroFiltros"]/table/tbody/tr[8]/td[2]/p
        ${PRECO_MEDIO}=    Remove String    ${PRECO_MEDIO}    R    $    .
        ${US_PRECO_MEDIO_ONLY_NUMBER}=    Replace String    ${PRECO_MEDIO}    ,    .
        ${saleProposal}=    Convert To Number    ${carData}[Price]    2
        ${fipeVALUE}=    Convert To Number    ${US_PRECO_MEDIO_ONLY_NUMBER}    2
        ${goodDeal}=    Evaluate    ${SaleProposal} <= (${fipeValue}*0.9)
        ${IS_GOOD_DEAL}=    Set Variable    Não
        IF    $gooddeal
            ${IS_GOOD_DEAL}=    Set Variable    Sim
        END
        ${fileNotExist}=    Does File Not Exist    %{ROBOT_ROOT}${/}result${/}informacoes_carros.xlsx
        &{newRow}=    Create Dictionary
        ...    Mês de Referência=${MES_DE_REFERENCIA}
        ...    Código Fipe=${CODIGO_FIPE}
        ...    Marca=${MARCA}
        ...    Modelo=${MODELO}
        ...    Ano Modelo=${ANO}
        ...    Autenticação=${AUTENTICACAO}
        ...    Data da Consulta=${DATA_DA_CONSULTA}
        ...    Preço Médio=${fipeVALUE}
        ...    É um bom negócio=${IS_GOOD_DEAL}
        IF    $filenotexist
            Create Workbook    %{ROBOT_ROOT}${/}result${/}informacoes_carros.xlsx    xlsx
            @{worksheetData}=    Create List    ${newRow}
            Create Worksheet    Fipe    ${worksheetData}    header=True
        ELSE
            Append Rows To Worksheet    ${newRow}
        END
        Auto Size Columns    A    I
        Save Workbook
        Click Element When Visible    xpath=//*[@id='buttonLimparPesquisarcarro']
        Sleep    15s
    END
