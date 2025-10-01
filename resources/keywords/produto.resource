*** Settings ***
Documentation    Keywords específicas para operações de produto
Library          RequestsLibrary
Library          Collections
Library          DateTime
Resource         ../variables.resource
Resource         login.resource

*** Keywords ***

Setup Produtos Suite
    [Documentation]    Cria sessão com a API e gera token global para os testes de produto
    Create Session    serverest    ${BASE_URL}
    Gerar Token Global

Gerar Nome Produto Unico
    [Documentation]    Gera um nome de produto único baseado no timestamp com milissegundos e número aleatório
    ${timestamp}=    Get Time    epoch
    ${microseconds}=    Evaluate    int(time.time() * 1000000) % 1000000    modules=time
    ${random}=    Evaluate    random.randint(1000, 9999)    modules=random
    ${unique_name}=    Set Variable    Produto${timestamp}${microseconds}${random}
    RETURN    ${unique_name}

Cadastrar Produto Valido
    [Documentation]    Cadastra produto válido e retorna dados. Se nome não for passado, gera automaticamente.
    [Arguments]    ${token}=${TOKEN_GLOBAL}    ${nome}=None    ${preco}=199    ${descricao}=Descrição do produto QA Automated    ${quantidade}=10
    ${nome}=    Run Keyword If    '${nome}'=='None'    Gerar Nome Produto Unico    ELSE    Set Variable    ${nome}
    ${payload}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=201
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*realizado.*sucesso
    RETURN    ${response}    ${nome}

Cadastrar Produto com Nome Duplicado
    [Documentation]    Tenta cadastrar produto com nome duplicado usando o nome passado
    [Arguments]    ${nome_existente}    ${token}=${TOKEN_GLOBAL}
    ${payload}=    Create Dictionary
    ...    nome=${nome_existente}
    ...    preco=150
    ...    descricao=Produto Duplicado Teste
    ...    quantidade=5
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=400
    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Should Match Regexp    ${response.json()['message']}    (?i)já.*existe.*produto
    RETURN    ${response}

Listar Produtos
    [Documentation]    Lista todos os produtos
    ${response}=    GET On Session    serverest    /produtos    expected_status=200
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    produtos
    Should Not Be Empty    ${response.json()['produtos']}
    RETURN    ${response}