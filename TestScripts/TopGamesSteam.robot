*** Settings ***
Library        RPA.Browser.Selenium
Library    Collections


*** Variables ***
${site}        https://store.steampowered.com/
@{name_list}
@{date_list}
@{price_list}
@{link_list}

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

*** Tasks ***
Open Steam's Top Games
    Open Page and Filter Games
    Get Top Games