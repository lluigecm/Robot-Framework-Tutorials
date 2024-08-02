*** Settings ***
Library        RPA.Browser.Selenium
Library        Collections
Library        RPA.Excel.Files
Library        RPA.Email.ImapSmtp


*** Variables ***
${site}               https://store.steampowered.com/
@{name_list}
@{date_list}
@{price_list}
@{link_list}
${email}              YourEmail
${password}           YourPassword
${path_anexos}        YourPath

*** Keywords ***
Open Page and Filter Games
    Open Browser    ${site}    browser=chrome    options=add_argument("--start-maximized")
    Click Element When Visible            //*[@id="responsive_page_template_content"]/div[3]/div[1]/div/div[1]/div[6]/a[1]

Get Top Games
    ${qnt_games}    Evaluate    100
    FOR     ${i}    IN RANGE    1    ${qnt_games}+1
        Scroll Element Into View                //*[@id="search_resultsRows"]/a[${i}]
        ${name}        Get Text                 //*[@id="search_resultsRows"]/a[${i}]/div[2]/div[1]/span
        ${date}        Get Text                 //*[@id="search_resultsRows"]/a[${i}]/div[2]/div[2]
        TRY
            ${price}       Get Text                 //*[@id="search_resultsRows"]/a[${i}]/div[2]/div[4]/div/div/div/div
        EXCEPT
            TRY
                ${price}       Get Text                 //*[@id="search_resultsRows"]/a[${i}]/div[2]/div[4]/div/div/div[3]/div[2]
            EXCEPT    
                ${price}       Evaluate                 "Insdisponível"
            END
        END
        ${link}        Get Element Attribute    //*[@id="search_resultsRows"]/a[${i}]    href
        Append To List    ${name_list}    ${name}
        Append To List    ${date_list}    ${date}
        Append To List    ${price_list}   ${price}
        Append To List    ${link_list}    ${link}
    END

Insert Data in Excel
    Create Workbook             TopGamesSteam.xlsx

    Set Cell Value    1    1    Nome
    Set Cell Value    1    2    Data de Lançamento
    Set Cell Value    1    3    Preço
    Set Cell Value    1    4    Link

    ${qnt}    Evaluate    len(${name_list})
    FOR    ${i}    IN RANGE    1    ${qnt}+1
        ${empty_line}        Find Empty Row

        Set Cell Value    ${empty_line}    1    ${name_list}[${i-1}]
        Set Cell Value    ${empty_line}    2    ${date_list}[${i-1}]
        Set Cell Value    ${empty_line}    3    ${price_list}[${i-1}]
        Set Cell Value    ${empty_line}    4    ${link_list}[${i-1}]
    END

    Save Workbook           YourPath/TopGamesSteam.xlsx

Send Data by Email
    Authorize Smtp    account=${email}    password=${password}    smtp_server=smtp-mail.outlook.com    smtp_port=587
    Send Message    sender=${email}    recipients=${email}    subject=TESTE STEAM    body=TOP 100 GAMES    attachments=${path_anexos}
    
*** Tasks ***
Open Steam's Top Games
    Open Page and Filter Games
    Get Top Games
    Insert Data in Excel
    Send Data by Email