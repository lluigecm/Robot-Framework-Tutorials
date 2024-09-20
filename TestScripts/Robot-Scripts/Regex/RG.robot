*** Settings ***
Library           OperatingSystem
Library           String


*** Variables ***
${nome_rgx}                [a-zA-Z]{4}[:]\\s[a-zA-Z]+\\s[a-zA-Z]+\\s.+
${nacionalidade_rgx}       [a-zA-Z]{13}[:]\\s.+
${naturalidade_rgx}        [a-zA-Z]{12}[:]\\s.+\\s[-]\\s[A-Z]{2}
${data_nasc_rgx}           [a-zA-Z]{4}\\s[a-z]{2}.+[:]\\s\\d{2}\\/\\d{2}\\/\\d{4}
${filicao_rgx}             .+[:]\\n\\W\\s[A-Za-z]{3}[:].+\\n\\W\\s.{3}[:]\\s.+
${sexo_rgx}                [A-Za-z]{4}[:]\\s[F||M].+
${emissao_rgx}             Emissão:.+
${orgao_expedidor_rgx}     Órgão.+
${n_doc_rgx}               [A-Za-zú]+[:]\\s\\d{9}

${arq_path}                ../Arquivos-Teste/rg.txt


*** Keywords ***
Formatar Informação
    [Arguments]    ${info}    ${rgx}
    ${info_formatada}=    Remove String Using Regexp    ${info}    ${rgx}
    RETURN    ${info_formatada}

Abrir Arquivo e Separar Informações
    ${file} =    Get File  ${arq_path}

    ${nome}=              Get Regexp Matches    ${file}    ${nome_rgx}
    ${nacionalidade}=     Get Regexp Matches    ${file}    ${nacionalidade_rgx}
    ${naturalidade}=      Get Regexp Matches    ${file}    ${naturalidade_rgx}
    ${data_nasc}=         Get Regexp Matches    ${file}    ${data_nasc_rgx}
    ${filicao}=           Get Regexp Matches    ${file}    ${filicao_rgx}
    ${sexo}=              Get Regexp Matches    ${file}    ${sexo_rgx}
    ${emissao}=           Get Regexp Matches    ${file}    ${emissao_rgx}
    ${orgao_expedidor}=   Get Regexp Matches    ${file}    ${orgao_expedidor_rgx}
    ${n_doc}=             Get Regexp Matches    ${file}    ${n_doc_rgx}

    ${nome}=              Formatar Informação   ${nome}[0]             .+[:]
    ${nacionalidade}=     Formatar Informação   ${nacionalidade}[0]    .+[:]
    ${naturalidade}=      Formatar Informação   ${naturalidade}[0]     .+[:]
    ${data_nasc}=         Formatar Informação   ${data_nasc}[0]        .+[:]
    ${filicao}=           Formatar Informação   ${filicao}[0]          Filiação:
    ${sexo}=              Formatar Informação   ${sexo}[0]             .+[:]
    ${emissao}=           Formatar Informação   ${emissao}[0]          .+[:]
    ${orgao_expedidor}=   Formatar Informação   ${orgao_expedidor}[0]  .+[:]
    ${n_doc}=             Formatar Informação   ${n_doc}[0]            .+[:]



*** Tasks ***
TRY
    Abrir Arquivo e Separar Informações
EXCEPT
    Log    Erro ao executar teste