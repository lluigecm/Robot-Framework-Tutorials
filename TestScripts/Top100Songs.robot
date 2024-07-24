*** Settings ***
Library          RPA.Browser.Selenium
Library          Collections
Library          RPA.FileSystem
Library          RPA.Excel.Files
Library          String

*** Variables ***
${site}              https://genius.com/
@{lista_autor}
@{lista_musica}
@{lista_acessos}

*** Keywords ***
Open Page
    Open Browser    ${site}    browser=chrome    options=add_argument("--start-maximized")

Open Music's List
    Set Selenium Timeout    5s
    WHILE    ${True}
        ${load_more}        Is Element Visible    //*[@id="top-songs"]/div/div[3]/div
        IF    ${load_more} == ${False}
            TRY    
                Wait Until Page Contains Element    //*[@id="top-songs"]/div/div[3]/div
                Scroll Element Into View            //*[@id="top-songs"]/div/div[3]/div
                Click Element                       //*[@id="top-songs"]/div/div[3]/div
            EXCEPT
                BREAK
            END
        ELSE
            Click Element        //*[@id="top-songs"]/div/div[3]/div
        Sleep        1s
        END
    END

Data Extraction
    ${qnt_musics}        Get Element Count        //*[@id="top-songs"]/div/div[2]/a
    FOR    ${song}    IN RANGE    1    ${qnt_musics}+1
        ${musica}        Get Text        //*[@id="top-songs"]/div/div[2]/a[${song}]/div[2]/h3/div[1]
        ${autor}         Get Text        //*[@id="top-songs"]/div/div[2]/a[${song}]/h4
        TRY
            ${acessos}       Get Text        //*[@id="top-songs"]/div/div[2]/a[${song}]/div[3]/div[2]/div/span
        EXCEPT
            ${acessos}       Get Text        //*[@id="top-songs"]/div/div[2]/a[${song}]/div[3]/div/div/span
        END
        Append To List    ${lista_musica}    ${musica}
        Append To List    ${lista_autor}     ${autor}
        Append To List    ${lista_acessos}   ${acessos}
    END

Insert in Excel File
    Create Workbook    Top100Songs.xlsx
    
    Set Cell Value     1    1    Música
    Set Cell Value     1    2    Autor
    Set Cell Value     1    3    Acessos

    ${qnt}    Get Length    ${lista_musica}
    FOR    ${aux}    IN RANGE    1    ${qnt}+1
        ${empty_line}        Find Empty Row

        Set Cell Value       ${empty_line}    1    ${lista_musica[${aux}-1]}
        Set Cell Value       ${empty_line}    2    ${lista_autor[${aux}-1]}
        Set Cell Value       ${empty_line}    3    ${lista_acessos[${aux}-1]}
    END
    Save Workbook    ${CURDIR}/Top100Songs.xlsx
    Close Workbook

*** Tasks **
Task 1
    Open Page
    Open Music's List
    Data Extraction
    Insert in Excel File