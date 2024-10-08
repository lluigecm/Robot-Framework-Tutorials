*** Settings ***
Library           OperatingSystem
Library           String

*** Variables ***
${arq_path}                        ../Arquivos-Teste/danfe.txt
${data_recebimento_rgx}            RECEBIMENTO\\n\\d{2}\\/\\d{2}\\/\\d{4}
${data_danfe_rgx}                  DANFE\\n\\d{2}\\/\\d{2}\\/\\d{4}
${entrega_&_termolabil_rgx}        [(]\\sX\\s[)]\\s\\w{3}
${afm_rgx}                         AFM.+
${n_danfe_rgx}                     DANFE:\\s\\d+
${prog_vinc_rgx}                   VINCULADO:.+
${valor_danfe_rgx}                 DANFE R\\W:.+
${recebedor_rgx}                   RECEBEDOR:.+
${conferente_rgx}                  CONFERENTE:.+
${descricao_rgx}                   DESCRIÇÃO.+\\n\\n.+
${fabricante_rgx}                  FABRICANTE:.+
${temp_rgx}                        TEMP:.+
${fator_embalagem_rgx}             EMBALAGEM:.+

*** Keywords ***
Formatar Informação
    [Arguments]    ${info}    ${rgx}
    ${info_formatada}=    Remove String Using Regexp    ${info}    ${rgx}
    RETURN    ${info_formatada}

Abrir Arquivo e Separar Informações
    ${file}=        Get File        ${arq_path}

    ${data_recebimento}=            Get Regexp Matches    ${file}       ${data_recebimento_rgx}
    ${data_danfe}=                  Get Regexp Matches    ${file}       ${data_danfe_rgx}
    ${entrega_&_termolabil}=        Get Regexp Matches    ${file}       ${entrega_&_termolabil_rgx}
    ${afm}=                         Get Regexp Matches    ${file}       ${afm_rgx}
    ${n_danfe}=                     Get Regexp Matches    ${file}       ${n_danfe_rgx}
    ${prog_vinc}=                   Get Regexp Matches    ${file}       ${prog_vinc_rgx}
    ${valor_danfe}=                 Get Regexp Matches    ${file}       ${valor_danfe_rgx}
    ${recebedor}=                   Get Regexp Matches    ${file}       ${recebedor_rgx}
    ${conferente}=                  Get Regexp Matches    ${file}       ${conferente_rgx}
    ${descricao}=                   Get Regexp Matches    ${file}       ${descricao_rgx}
    ${fabricante}=                  Get Regexp Matches    ${file}       ${fabricante_rgx}
    ${temp}=                        Get Regexp Matches    ${file}       ${temp_rgx}
    ${fator_embalagem}=             Get Regexp Matches    ${file}       ${fator_embalagem_rgx}

    ${data_recebimento}=            Formatar Informação   ${data_recebimento}[0]            RECEBIMENTO\\n
    ${data_danfe}=                  Formatar Informação   ${data_danfe}[0]                  DANFE\\n
    ${entrega}=                     Formatar Informação   ${entrega_&_termolabil}[0]        [(]\\sX\\s[)]\\s
    ${termolabil}=                  Formatar Informação   ${entrega_&_termolabil}[1]        [(]\\sX\\s[)]\\s
    ${afm}=                         Formatar Informação   ${afm}[0]                         .+:\\s
    ${n_danfe}=                     Formatar Informação   ${n_danfe}[0]                     .+:\\s
    ${prog_vinc}=                   Formatar Informação   ${prog_vinc}[0]                   .+:\\s
    ${valor_danfe}=                 Formatar Informação   ${valor_danfe}[0]                 .+:\\s
    ${recebedor}=                   Formatar Informação   ${recebedor}[0]                   .+:\\s
    ${conferente}=                  Formatar Informação   ${conferente}[0]                  .+:\\s
    ${descricao}=                   Formatar Informação   ${descricao}[0]                   .+:\\n\\n
    ${fabricante}=                  Formatar Informação   ${fabricante}[0]                  .+:
    ${temp}=                        Formatar Informação   ${temp}[0]                        .+:\\s
    ${fator_embalagem}=             Formatar Informação   ${fator_embalagem}[0]             .+:\\s


*** Tasks ***
TRY
    Abrir Arquivo e Separar Informações
EXCEPT
    Log    Erro ao executar teste